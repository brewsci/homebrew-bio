class Figtree < Formula
  desc "Graphical viewer of phylogenetic trees"
  homepage "http://tree.bio.ed.ac.uk/software/figtree/"
  url "https://github.com/rambaut/figtree/releases/download/v1.4.4/FigTree_v1.4.4.tgz"
  sha256 "529b867657b29e369cf81cd361e6a76bd713d488a63b91932df2385800423aa8"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "46dded66c63bcc052039c5de56c770831ee21077c801be8b64bb428bf25b1f80" => :sierra
    sha256 "0dfa41c23b48cef3c43359faa55552ccc927f68fbcaf3749168c6de4c64c1c76" => :x86_64_linux
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
