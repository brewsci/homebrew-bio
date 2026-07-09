class StarAligner < Formula
  # cite Dobin_2012: "https://doi.org/10.1093/bioinformatics/bts635"
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  url "https://github.com/alexdobin/STAR/archive/refs/tags/2.7.11b.tar.gz"
  version "2.7.11b"
  sha256 "3f65305e4112bd154c7e22b333dcdaafc681f4a895048fa30fa7ae56cac408e7"
  license "MIT"
  revision 1
  head "https://github.com/alexdobin/STAR.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b42671b58ac40619f1fefb5b0510f8cdb7d4e995e8452987568cb1943b2e87c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c17409b14473b0d63518915e164317dcdbaf00d5c30e87d72b885bdca4742fb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc738cb20af24f2adb10727171ff3262afa05d7feb3c13a14dbe3f3e060457c"
    sha256 cellar: :any,                 x86_64_linux:  "6c2489a84b307a479adab86d2ae8f2d78888e26b3fb4ae991038091d1227edf8"
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  # Fix STAR reporting 0 input reads on macOS (libc++ ignores setbuf).
  # https://github.com/alexdobin/STAR/pull/2691
  patch do
    url "https://github.com/alexdobin/STAR/commit/14b1f235927e75ff927be08134c1fb6a00c14d79.patch?full_index=1"
    sha256 "f12a27b4f1381b591011de118f715bd93ea32e87d26c60f13aa246f67191d9db"
  end

  def install
    cd "source" do
      if OS.mac?
        inreplace "Makefile", "-static-libgcc", ""
        args = ["STARforMacStatic", "STARlongForMacStatic"]
        # opal bundles SIMDe, which lowers its AVX2 intrinsics to NEON on Apple
        # Silicon; the Makefile's default -mavx2 is x86-only and a hard error
        # under clang on arm64.
        args.unshift "CXXFLAGS_SIMD=" if Hardware::CPU.arm?
        system "make", *args
      else
        system "make", "STAR", "STARlong"
      end
      bin.install "STAR", "STARlong"
    end
    doc.install "doc/STARmanual.pdf"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/STAR --help")
    assert_match "Usage:", shell_output("#{bin}/STARlong --help")

    # Build a tiny genome, derive one read from it, and confirm STAR actually
    # ingests the read. Guards against the macOS libc++ setbuf bug (STAR
    # PR #2691) where STAR ran with exit 0 but reported 0 input reads.
    bases = "ACGT"
    lcg = 1
    genome = +""
    2000.times do
      lcg = ((1_103_515_245 * lcg) + 12_345) & 0x7fffffff
      genome << bases[(lcg >> 16) & 3]
    end
    (testpath/"ref.fa").write ">chr1\n#{genome}\n"

    read = genome[500, 50]
    (testpath/"reads.fq").write "@r1\n#{read}\n+\n#{"I" * read.length}\n"

    (testpath/"genome").mkpath
    system bin/"STAR", "--runMode", "genomeGenerate", "--genomeDir", "genome",
           "--genomeFastaFiles", "ref.fa", "--genomeSAindexNbases", "4",
           "--runThreadN", "1"
    system bin/"STAR", "--runMode", "alignReads", "--genomeDir", "genome",
           "--readFilesIn", "reads.fq", "--outFileNamePrefix", "out_",
           "--runThreadN", "1"

    input_reads = (testpath/"out_Log.final.out").read[/Number of input reads\s*\|\s*(\d+)/, 1]
    assert_equal "1", input_reads,
                 "STAR reported #{input_reads.inspect} input reads; the macOS " \
                 "libc++ setbuf bug (STAR PR #2691) is present"
  end
end
