class Crass < Formula
  # cite Skennerton_2013: "https://doi.org/10.1093/nar/gkt183"
  desc "The CRISPR assembler"
  homepage "https://ctskennerton.github.io/crass"
  url "https://github.com/ctSkennerton/crass/archive/v1.0.1.tar.gz"
  sha256 "7078bcccb7a16bf4f2e54590f25d85f36d27d1bbaa9f2c484d4eaa81a5ead930"
  head "https://github.com/ctSkennerton/crass.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "graphviz"
  depends_on "xerces-c"
  depends_on "zlib" unless OS.mac?

  def install
    system "./autogen.sh"
    system "./configure", "--enable-rendering", "--prefix=#{prefix}"

    system "make", "install"

    pkgshare.install "test"
    pkgshare.install "scripts"
    pkgshare.install "doc/manual.tex"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/crass", 1)

    cp_r pkgshare/"test/poor_dr_ext.fa.gz", testpath
    assert_match "1 CRISPRs found!", shell_output("#{bin}/crass #{testpath}/poor_dr_ext.fa.gz")
  end
end
