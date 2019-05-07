class Figtree < Formula
  desc "Graphical viewer of phylogenetic trees"
  homepage "http://tree.bio.ed.ac.uk/software/figtree/"
  url "https://github.com/rambaut/figtree/releases/download/v1.4.4/FigTree_v1.4.4.tgz"
  sha256 "529b867657b29e369cf81cd361e6a76bd713d488a63b91932df2385800423aa8"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    rebuild 1
    sha256 "aa0742bb3801a0fe5944a652b1c45900f50544619c2252158eedab1f1438301a" => :sierra
  end

  depends_on :java

  def install
    prefix.install "lib/figtree.jar", "images"
    bin.write_jar_script prefix/"figtree.jar", "figtree"
    pkgshare.install Dir["*.tree"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/figtree -help 2>&1")
  end
end
