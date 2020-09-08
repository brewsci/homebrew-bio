class Hisat2 < Formula
  # cite Kim_2015: "https://doi.org/10.1038/nmeth.3317"
  desc "Graph-based alignment to a population of genomes"
  homepage "https://daehwankimlab.github.io/hisat2/"
  url "https://github.com/DaehwanKimLab/hisat2/archive/v2.2.0.tar.gz"
  sha256 "429882d90ad9c600a986279b3ca5d78573caacf3bf0d780c802c006d4fcf0a01"
  license "GPL-3.0"
  head "https://github.com/DaehwanKimLab/hisat2.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fa0b379de74c8f9b952d57693a93d8d7f664ca476d970608a25f3d1786c3d94e" => :catalina
    sha256 "0266c2eaad48f32bbe1b8ba9ed39e6fae3d9c1fbfb70f285d9bf2960d5093842" => :x86_64_linux
  end

  fails_with :clang

  def install
    system "make"
    rm "HISAT2-genotype.png"
    bin.install "hisat2", Dir["hisat2-*"]
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/hisat2 --help 2>&1")
  end
end
