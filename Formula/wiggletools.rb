class Wiggletools < Formula
  # cite Zerbino_2013: "https://doi.org/10.1093/bioinformatics/btt737"
  desc "Compute genome-wide statistics with composable iterators"
  homepage "https://github.com/Ensembl/WiggleTools"
  url "https://github.com/Ensembl/WiggleTools/archive/v1.2.7.tar.gz"
  sha256 "62eb04eed3f1be3b2adbcc7627cae44093680aa73a48f99d8621cfd85a92750c"
  head "https://github.com/Ensembl/WiggleTools.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "6a426c5c44bc2f8c2651e650f8502fa069b7eb86d696c35a5dbf82ca992461cf" => :catalina
    sha256 "22cf764321e896b7ee0abab938892e460f37e7f543bd6f1e086c5e895070b4a2" => :x86_64_linux
  end

  depends_on "gsl"
  depends_on "htslib"
  depends_on "libbigwig"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "make"
    pkgshare.install "test"
    lib.install "lib/libwiggletools.a"
    bin.install "bin/wiggletools"
  end

  test do
    assert_match "Command line", shell_output("#{bin}/wiggletools --help")

    if which "python2.7"
      cp_r pkgshare/"test", testpath
      cp_r prefix/"bin", testpath
      cd "test" do
        system "python2.7", "test.py"
      end
    end
  end
end
