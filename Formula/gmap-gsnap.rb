class GmapGsnap < Formula
  # cite Wu_2010: "https://doi.org/10.1093/bioinformatics/btq057"
  desc "Genomic Mapping & Alignment Program for RNA/EST/Short-read sequences"
  homepage "http://research-pub.gene.com/gmap/"
  url "http://research-pub.gene.com/gmap/src/gmap-gsnap-2019-09-12.tar.gz"
  sha256 "1bf242eef2ad0ab0280c41fc28b44a5107e90bcba64b37cf1579e1793e892505"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9e68cba9eb57c3ef57f1de83fff06967a2fd7f48740288e0bef75b0392fe71d3" => :mojave
    sha256 "19a643b9dc76c497865d910dd38f758ea56ba0c08954cbb212aba5490f0d907b" => :x86_64_linux
  end

  depends_on "samtools"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # homebrew currently supports SSE4.2 and don't want to force AVX-512
    system "./configure", "--prefix=#{prefix}", "--with-simd-level=sse42"
    system "make"
    ENV.deparallelize
    system "make", "check"
    system "make", "install"
  end

  def caveats
    <<~EOS
      You will need to either download or build indexed search databases.
      See the readme file for how to do this:
        http://research-pub.gene.com/gmap/src/README

      Databases will be installed to:
        #{share}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsnap --version 2>&1")
  end
end
