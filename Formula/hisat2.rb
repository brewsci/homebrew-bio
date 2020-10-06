class Hisat2 < Formula
  # cite Kim_2015: "https://doi.org/10.1038/nmeth.3317"
  desc "Graph-based alignment to a population of genomes"
  homepage "https://daehwankimlab.github.io/hisat2/"
  url "https://github.com/DaehwanKimLab/hisat2/archive/v2.2.1.tar.gz"
  sha256 "f3f4f867d0a6b1f880d64efc19deaa5788c62050e0a4d614ce98b3492f702599"
  license "GPL-3.0"
  head "https://github.com/DaehwanKimLab/hisat2.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "2b5b75097703eca1abde911453cf0751395f52d07c7e9d437becd35b8f5b3290" => :catalina
    sha256 "81d4a8bdf5de5751f06def926c8f7b39b2ee9e1d48905fbe7084cdaa0238f8b1" => :x86_64_linux
  end

  fails_with :clang

  def install
    system "make"
    rm "HISAT2-genotype.png"
    bin.install "hisat2", Dir["hisat2-*"], Dir["hisat2_*.py"]
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/hisat2 --help 2>&1")
  end
end
