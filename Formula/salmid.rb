class Salmid < Formula
  desc "Rapid confirmation of Salmonella species from WGS"
  homepage "https://github.com/hcdenbakker/SalmID"
  url "https://github.com/hcdenbakker/SalmID/archive/0.122.tar.gz"
  sha256 "cc0c422d8fe2f4f6c745ee2285557b1e69c12e0a69f08cfeadd06bca9ee7b83b"

  depends_on "python"

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../SalmID.py"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/SalmID.py --version")
  end
end
