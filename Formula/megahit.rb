class Megahit < Formula
  # cite Li_2015: "https://doi.org/10.1093/bioinformatics/btv033"
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  url "https://github.com/voutcn/megahit/archive/v1.2.9.tar.gz"
  sha256 "09026eb07cc4e2d24f58b0a13f7a826ae8bb73da735a47cb1cbe6e4693118852"
  head "https://github.com/voutcn/megahit.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "be4a9c2e1a53605dd1ea800783343ef14214f88a07b08ec7e5c601be47701a72" => :catalina
    sha256 "95ca23bbbe59d007edec3d972a95afbc626b0a740430d088fddd79837e5589cf" => :x86_64_linux
  end

  depends_on "cmake" => :build

  depends_on "gcc" if OS.mac? # needs openmp

  depends_on "python"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    inreplace "src/megahit", "#!/usr/bin/env python", "#!/usr/bin/env python3"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    outdir = "megahit.outdir"
    system "#{bin}/megahit", "--12", "#{pkgshare}/test_data/r2.il.fa.bz2", "-o", outdir
    assert_predicate testpath/"#{outdir}/final.contigs.fa", :exist?
    assert_match version.to_s, shell_output("#{bin}/megahit_toolkit dumpversion 2>&1")
  end
end
