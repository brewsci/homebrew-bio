class Phylobayes < Formula
  # cite Lartillot_2009: "https://doi.org/10.1093/bioinformatics/btp368"
  desc "Phylogenetic reconstruction using infinite mixtures"
  homepage "http://megasun.bch.umontreal.ca/People/lartillot/www/download.html"
  url "https://github.com/bayesiancook/phylobayes/archive/v4.1e.tar.gz"
  version "4.1e"
  sha256 "ab88c65844db76f3229a088825153b04c1ce59f129805ddb75a7728920b31304"

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
