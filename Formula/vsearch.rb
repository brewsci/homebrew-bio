class Vsearch < Formula
  # cite Rognes_2017: "https://doi.org/10.5281/zenodo.275113"
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.14.1.tar.gz"
  sha256 "388529a39eb0618a09047bf91e0a8ae8c9fd851a05f8d975e299331748f97741"
  head "https://github.com/torognes/vsearch.git"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "40752ce646e158f551a3f8b8c97879426ddbafe77683dfe2e57f193548dcbfdb" => :mojave
    sha256 "18aaea48ac36e09cc9b285e7e68a15f4b622f9bfe5f338c8916bda31abe9e9d2" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-pdfman"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vsearch --help 2>&1")
  end
end
