class Figtree < Formula
  desc "Graphical viewer of phylogenetic trees"
  homepage "http://tree.bio.ed.ac.uk/software/figtree/"
  url "https://github.com/rambaut/figtree/releases/download/v1.4.3/FigTree_v1.4.3.tgz"
  sha256 "f497d4dd3a6d220f6b62495b6f47a12ade50d87dbd8d6089f168e94d202f937b"

  depends_on :java

  def install
    prefix.install "lib/figtree.jar", "images"
    bin.write_jar_script prefix/"figtree.jar", "figtree"
    pkgshare.install Dir["*.tree"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/figtree -help 2>&1", 0)
  end
end
