class Wiggletools < Formula
  # cite Zerbino_2013: "https://doi.org/10.1093/bioinformatics/btt737"
  desc "Compute genome-wide statistics with composable iterators"
  homepage "https://github.com/Ensembl/WiggleTools"
  url "https://github.com/Ensembl/WiggleTools/archive/v1.2.8.tar.gz"
  sha256 "0c2119480208ae09ea3eba249c1a3a69bcccbdb97dcd1fb2e55f3deee0404b73"
  head "https://github.com/Ensembl/WiggleTools.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    rebuild 1
    sha256 cellar: :any, catalina:     "ac725d8c138b6856b9165de7372d8a93e095c44bed92174d79c8252b95a038b6"
    sha256 cellar: :any, x86_64_linux: "cc4901b957a523c60317e766e89af6c4c5831583d41607d575b8963c6c6062f7"
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
