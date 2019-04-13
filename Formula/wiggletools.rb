class Wiggletools < Formula
  # cite Zerbino_2013: "https://doi.org/10.1093/bioinformatics/btt737"
  desc "Compute genome-wide statistics with composable iterators"
  homepage "https://github.com/Ensembl/WiggleTools"
  url "https://github.com/Ensembl/WiggleTools/archive/v1.2.3.tar.gz"
  sha256 "2adc6c0f1738e604aa20a60b1c79ea36bc8cd030a2b6039b8e5ddc31c2bf846c"
  head "https://github.com/Ensembl/WiggleTools.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "db1f34f8201aa5b03453e31e06244322d9ab2be20cc29db42becc59be72cc96f" => :sierra
    sha256 "d77d48a9a8975a81bb7c744c12a01ca16819c1a2e5bac798c993329d3ab3fe66" => :x86_64_linux
  end

  depends_on "gsl"
  depends_on "htslib"
  depends_on "libbigwig"
  depends_on "python@2" => :test
  unless OS.mac?
    depends_on "curl"
    depends_on "zlib"
  end

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
      system "python2", "test.py"
    end
  end
end
