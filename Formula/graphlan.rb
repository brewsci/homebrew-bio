class Graphlan < Formula
  desc "Render circular taxonomic and phylogenetic trees"
  homepage "https://bitbucket.org/nsegata/graphlan/wiki/Home"
  url "https://hg@bitbucket.org/nsegata/graphlan/get/1.1.2.tar.bz2"
  sha256 "c417ca2c5789dc264393427e448422ae1877a47a5169d4ed41ec54f3dcabb011"

  depends_on "matplotlib"

  def install
    prefix.install Dir["*.py"], "src/pyphlan.py"
    bin.install_symlink "../graphlan.py" => "graphlan"
    bin.install_symlink "../graphlan_annotate.py" => "graphlan_annotate"
    pkgshare.install "examples"
    doc.install "license.txt", "readme.txt"
  end

  test do
    dir = pkgshare/"examples/simple"
    xml = "out.xml"
    png = "out.png"
    assert_predicate xml, :exist?
    assert_predicate png, :exist?
    assert_match "Usage", shell_output("#{bin}/graphlan_annotate #{dir}/core_genes.txt xml --annot #{dir}/annot.txt 2>&1", 255)
    assert_match "Usage", shell_output("#{bin}/graphlan xml png --dpi 150 --size 4 --pad 0.2 2>&1", 255)
  end
end
