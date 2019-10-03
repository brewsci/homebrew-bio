class Vsearch < Formula
  # cite Rognes_2017: "https://doi.org/10.5281/zenodo.275113"
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.14.1.tar.gz"
  sha256 "388529a39eb0618a09047bf91e0a8ae8c9fd851a05f8d975e299331748f97741"
  head "https://github.com/torognes/vsearch.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "a2f608173d44c07b4ab8be70b491bea725eea0e1aca2b6ec2c2e39be5ec041d8" => :sierra
    sha256 "be53bea06af34f1eb38b7228c7f51b98f08636c4ca141ca7fa991a1d68f641ce" => :x86_64_linux
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
