class Andi < Formula
  # cite Hauboid_2015: "https://doi.org/10.1093/bioinformatics/btu815"
  desc "Estimate evolutionary distance between similar genomes"
  homepage "https://github.com/EvolBioInf/andi"
  url "https://github.com/EvolBioInf/andi/archive/v0.13.tar.gz"
  sha256 "3fb11f5399efdcbf98ecbbaa95b1a6cd98f887cf78554e460dc3f18d4880ae3e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "78dcbf43bcb4cde0ba46cd02af556afceef520a7f04e998fea7d5b2910add590" => :catalina
    sha256 "7ce8d573d03707e62060cb894e8b66779f1cd4190647d9ae0892cf0f87ceb580" => :x86_64_linux
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
