class GenomePainter < Formula
  desc "Paint genomes with taxa-specific k-mer probabilities"
  homepage "https://github.com/scwatts/genome_painter"
  url "https://github.com/scwatts/genome_painter/archive/v0.0.8.tar.gz"
  sha256 "434d81b4ed301f14aa3e9a55fdeeefab295264aa82410482abda23655e7a18bd"
  license "GPL-3.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "abb5dcc8c48f0bf65f997fb5d78b6200c8f9ad8a4493670faaf4bd0bc676cd0b" => :catalina
    sha256 "f21a21128af05cdf73453c466b683feb79546bf9f2244495b9e14de04cb04d11" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # needs openmp

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/genomepainter_paint_genome --version 2>&1")
  end
end
