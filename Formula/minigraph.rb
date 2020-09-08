class Minigraph < Formula
  desc "Proof-of-concept seq-to-graph mapper and graph generator"
  homepage "https://lh3.github.io/minigraph"
  url "https://github.com/lh3/minigraph/archive/v0.10.tar.gz"
  sha256 "993c8077c7263166fe3386d29f37a20726fa27011d3365363c646cfbe88441f1"
  license "MIT"
  head "https://github.com/lh3/minigraph.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9dcb1abd6ccc96b5910276f3690542be85ab68bb6c33c0c096736a17f13fc01c" => :catalina
    sha256 "fadf58602f216a3f4faac81eaad58fe0bdda70e4200fa102a5c6cfd2c528d49e" => :x86_64_linux
  end

  depends_on "k8"
  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "minigraph", "misc/mgutils.js"
    bin.install_symlink "mgutils.js" => "mgutils"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/minigraph 2>&1", 1)
    assert_match "Usage", shell_output("#{bin}/mgutils", 1)
  end
end
