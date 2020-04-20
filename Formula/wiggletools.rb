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
    sha256 "ae3b7f504b648dbf02885956bdcc1d0fe2cea35248e3c6052a8f53a46adc4694" => :catalina
    sha256 "331ca29f300399ba0e4fe1aec7fc378e536c149b740b7e5cfa2ada574be0ca12" => :x86_64_linux
  end

  depends_on "gsl"
  depends_on "htslib"
  depends_on "libbigwig"

  # uses_from_macos "python@2" => :test
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "make"
    pkgshare.install "test"
    lib.install "lib/libwiggletools.a"
    bin.install "bin/wiggletools"
  end

  test do
    cp_r pkgshare/"test", testpath
    cp_r prefix/"bin", testpath
    cd "test" do
      system "python2.7", "test.py"
    end
  end
end
