class Minigraph < Formula
  desc "Proof-of-concept seq-to-graph mapper and graph generator"
  homepage "https://lh3.github.io/minigraph"
  url "https://github.com/lh3/minigraph/archive/v0.2.tar.gz"
  sha256 "5474b8faf44e202a86670bb68919cbcc6012f1b66b76b5eebd2aaee969a097cd"
  head "https://github.com/lh3/minigraph.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e426ffbb8e00b96381a63acfc657ee130b0baa0e74d27cd7c9794f908dd54a32" => :sierra
    sha256 "91a8efd4052fd54d4456180a2a994ded487d799e9cd5f3efb457f79ae01a348c" => :x86_64_linux
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
