class Verticalize < Formula
  desc "Simple tool to verticalize text delimited files"
  homepage "https://github.com/lindenb/verticalize"
  url "https://github.com/lindenb/verticalize/archive/v1.0.1.tar.gz"
  sha256 "e8aeb3e1ce0e836aa5e47ccfe75578eb96240e5d181a78396b375bc9916d331a"

  def install
    system "make"
    system "make", "test"
    bin.install "verticalize"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/verticalize -v ")
  end
end
