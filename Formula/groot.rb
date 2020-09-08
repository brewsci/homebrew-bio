class Groot < Formula
  # cite Rowe_2018: "https://doi.org/10.1093/bioinformatics/bty387"
  desc "Resistome profiler for Graphing Resistance Out Of meTagenomes"
  homepage "https://github.com/will-rowe/groot"
  license "MIT"
  if OS.mac?
    url "https://github.com/will-rowe/groot/releases/download/1.1.2/groot_osx.gz"
    sha256 "49b3d29b3d87227ba1c1339c6e6f401e740da0f5a58032f706c94fcb56581c9b"
  elsif OS.linux?
    url "https://github.com/will-rowe/groot/releases/download/1.1.2/groot_linux.gz"
    sha256 "dfb033e81c90fc5a02d2e2f51e146a707e2bd589c23b43006593079e83db2b6f"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "d68dae4fdc75db0240dac1235294e34aaa5cee4437228c0a97220993ffe56a62" => :catalina
    sha256 "57339d9d43a15d769de59a51ea39d6c8212763babd978e5ca135fd86bc9b2af4" => :x86_64_linux
  end

  def install
    bin.install Dir["groot_*"].first => "groot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/groot version 2>&1")
    assert_match "@@@@@@@", shell_output("#{bin}/groot iamgroot 2>&1")
  end
end
