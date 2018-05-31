class GenomePainter < Formula
  desc "Paint genomes with taxa-specific k-mer probabilities"
  homepage "https://github.com/scwatts/genome_painter"
  url "https://github.com/scwatts/genome_painter/archive/v0.0.6.tar.gz"
  sha256 "8003983616da844be548f2ba54bf16353b7c815d6f44642f0d88211162248bfa"

  fails_with :clang # needs openmp

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gcc" # for openmp
  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paint_genome --version 2>&1")
  end
end
