class Groot < Formula
  # cite Rowe_2018: "https://doi.org/10.1093/bioinformatics/bty387"
  desc "Resistome profiler for Graphing Resistance Out Of meTagenomes"
  homepage "https://github.com/will-rowe/groot"
  if OS.mac?
    url "https://github.com/will-rowe/groot/releases/download/1.1.2/groot_osx.gz"
    sha256 "49b3d29b3d87227ba1c1339c6e6f401e740da0f5a58032f706c94fcb56581c9b"
  elsif OS.linux?
    url "https://github.com/will-rowe/groot/releases/download/1.1.2/groot_linux.gz"
    sha256 "dfb033e81c90fc5a02d2e2f51e146a707e2bd589c23b43006593079e83db2b6f"
  end

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "d1594f5953a4578c4c9d842d8bf115a31da9702a30809969e62fcb715e4587f2" => :sierra
    sha256 "d29ed2ac8a75a997bd4fad81c578af10a94dc8a20f68ab98c3c779ed9f5ed2bc" => :x86_64_linux
  end

  def install
    bin.install Dir["groot_*"].first => "groot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/groot version 2>&1")
    assert_match "@@@@@@@", shell_output("#{bin}/groot iamgroot 2>&1")
  end
end
