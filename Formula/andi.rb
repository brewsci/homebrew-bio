class Andi < Formula
  # cite Hauboid_2015: "https://doi.org/10.1093/bioinformatics/btu815"
  desc "Estimate evolutionary distance between similar genomes"
  homepage "https://github.com/EvolBioInf/andi"
  url "https://github.com/EvolBioInf/andi/archive/v0.14.tar.gz"
  sha256 "2c9e11524f38e74fe3f981e6acd9527c1a1ca30994a30c5e86808ba5165a25b7"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "78dcbf43bcb4cde0ba46cd02af556afceef520a7f04e998fea7d5b2910add590"
    sha256 cellar: :any, x86_64_linux: "7ce8d573d03707e62060cb894e8b66779f1cd4190647d9ae0892cf0f87ceb580"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gsl"
  depends_on "libdivsufsort"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/andi --version 2>&1")
  end
end
