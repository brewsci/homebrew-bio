class Filtlong < Formula
  desc "Quality filtering of long noisy DNA sequencing reads"
  homepage "https://github.com/rrwick/Filtlong"
  url "https://github.com/rrwick/Filtlong/archive/v0.2.0.tar.gz"
  sha256 "a4afb925d7ced8d083be12ca58911bb16d5348754e7c2f6431127138338ee02a"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f587624c4b2dcf5c3b746b3fbf34e20e9ff5839d4fc80256035b23d834d05524" => :sierra
    sha256 "446414903f438e372b2548d88f2c601c428f5f105ddd39d457312959e7f73ece" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    system "make"
    bin.install "bin/filtlong"
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filtlong --version 2>&1")
    system bin/"filtlong", "--min_length", "1000", pkgshare/"test/test_trim.fastq"
  end
end
