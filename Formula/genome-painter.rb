class GenomePainter < Formula
  desc "Paint genomes with taxa-specific k-mer probabilities"
  homepage "https://github.com/scwatts/genome_painter"
  url "https://github.com/scwatts/genome_painter/archive/v0.0.6.tar.gz"
  sha256 "8003983616da844be548f2ba54bf16353b7c815d6f44642f0d88211162248bfa"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "b5bee7ec1ba40a4f7ef98a00d39866d85de24cb23ec2a74861bee803eb07220a" => :sierra
    sha256 "466bc33dade80e94cfb92578be6c4f71e68bb5f6b50f0131bd346accc7642ee0" => :x86_64_linux
  end

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
