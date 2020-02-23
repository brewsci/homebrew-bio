class Phylobayes < Formula
  # cite Lartillot_2009: "https://doi.org/10.1093/bioinformatics/btp368"
  desc "Phylogenetic reconstruction using infinite mixtures"
  homepage "http://megasun.bch.umontreal.ca/People/lartillot/www/download.html"
  url "https://github.com/bayesiancook/phylobayes/archive/v4.1e.tar.gz"
  version "4.1e"
  sha256 "ab88c65844db76f3229a088825153b04c1ce59f129805ddb75a7728920b31304"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "d64caf0698e161e24cd60ef993d3033af9629286ccf60ffd7c4ffd2d21acb2a3" => :mojave
    sha256 "95bd708818d15ab41d8528119a1b63007e687db51c130c35029e68fb29e0357d" => :x86_64_linux
  end

  def install
    pkgshare.install Dir["data/*"]
    system "make", "-C", "sources"
    bin.install Dir["data/*"]
  end

  test do
    cp Dir[pkgshare/"brpo/*"], testpath
    system "#{bin}/pb", "-t", "brpo.tree", "-d", "brpo.ali", "-x", "1", "10", "test"
  end
end
