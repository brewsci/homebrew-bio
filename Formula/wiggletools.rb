class Wiggletools < Formula
  # cite Zerbino_2013: "https://doi.org/10.1093/bioinformatics/btt737"
  desc "Compute genome-wide statistics with composable iterators"
  homepage "https://github.com/Ensembl/WiggleTools"
  url "https://github.com/Ensembl/WiggleTools/archive/v1.2.3.tar.gz"
  sha256 "2adc6c0f1738e604aa20a60b1c79ea36bc8cd030a2b6039b8e5ddc31c2bf846c"
  revision 1
  head "https://github.com/Ensembl/WiggleTools.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    rebuild 1
    sha256 "ebbd8e7c64cf65aabbdf7cdeefac77a1e905ad88c578b4192e333c6e48347d81" => :catalina
    sha256 "8f7b446e085dee1e9ebed51632a31d663eb9236778830a615a6ed281b76f0233" => :x86_64_linux
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
