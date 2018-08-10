class Vsearch < Formula
  # cite Rognes_2017: "https://doi.org/10.5281/zenodo.275113"
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.8.1.tar.gz"
  sha256 "45cfcb3ca494e9980e8e485c6aed70fb678c2edd522245f4192561a106d6161f"
  revision 1
  head "https://github.com/torognes/vsearch.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-pdfman"
    system "make", "install"
  end

  test do
    assert_match "allpairs_global", shell_output("#{bin}/vsearch --help 2>&1")
  end
end
