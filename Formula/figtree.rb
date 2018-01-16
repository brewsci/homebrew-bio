class Figtree < Formula
  desc "Graphical viewer of phylogenetic trees"
  homepage "http://tree.bio.ed.ac.uk/software/figtree/"
  url "https://github.com/rambaut/figtree/releases/download/v1.4.3/FigTree_v1.4.3.tgz"
  sha256 "f497d4dd3a6d220f6b62495b6f47a12ade50d87dbd8d6089f168e94d202f937b"

  bottle do
    prefix "/usr/local"
    cellar :any_skip_relocation
    sha256 "62c922559c551d7797512df38b655daf3d21222ead70509547ffc2c36c52a95e" => :sierra
    sha256 "89e4c4e4358903f832fc28028cd2203963dc9e1b5647cf910f8654bbd76b4dcc" => :x86_64_linux
  end

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
