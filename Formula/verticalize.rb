class Verticalize < Formula
  desc "Simple tool to verticalize text delimited files"
  homepage "https://github.com/lindenb/verticalize"
  url "https://github.com/lindenb/verticalize/archive/v1.0.1.tar.gz"
  sha256 "e8aeb3e1ce0e836aa5e47ccfe75578eb96240e5d181a78396b375bc9916d331a"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "cc01630a582a00db26eb35fbb1706ec8a98d987bf0d93596e60b0e5a744f3515"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5c1b1ee9fe0b8c955f271745f0cbef8bcc34a09bc453144c44268e7ca4ea370f"
  end

  def install
    system "make"
    system "make", "test"
    bin.install "verticalize"
    man1.install "verticalize.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/verticalize -v ")
  end
end
