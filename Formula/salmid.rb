class Salmid < Formula
  desc "Rapid confirmation of Salmonella species from WGS"
  homepage "https://github.com/hcdenbakker/SalmID"
  url "https://github.com/hcdenbakker/SalmID/archive/0.122.tar.gz"
  sha256 "cc0c422d8fe2f4f6c745ee2285557b1e69c12e0a69f08cfeadd06bca9ee7b83b"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6aefedde63baa9520c8a5100c3fbaf136b11ce025671f1145ec375ce5eca666f" => :sierra
    sha256 "f65d345e44e6e7ed6c5ece6cd3cd5ff1a460c1adfdd00e37a67cc1d0d9953c93" => :x86_64_linux
  end

  depends_on "python"

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../SalmID.py"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/SalmID.py --version")
  end
end
