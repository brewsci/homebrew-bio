class Metaphlan < Formula
  # cite Segata_2012: "https://doi.org/10.1038/nmeth.2066"
  desc "MetaPhlAn: Metagenomic Phylogenetic Analysis"
  homepage "https://huttenhower.sph.harvard.edu/metaphlan"
  url "https://bitbucket.org/nsegata/metaphlan/get/default.tar.bz2"
  version "1.7.8"
  sha256 "7113e00d2fe3aa1a8dcfce954a0b7ffd6ca9d726f5b3636b9f1d66a9c9254108"

  bottle :unneeded

  depends_on "bowtie2"
  depends_on "numpy"
  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../metaphlan.py"
    bin.install_symlink "../metaphlan.py" => "metaphlan"
  end

  test do
    system "#{bin}/metaphlan", "--version"
  end
end
