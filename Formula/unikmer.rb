class Unikmer < Formula
  desc "Manipulate small kmers without frequency information"
  homepage "https://github.com/shenwei356/unikmer"
  version "0.11.0"
  if OS.mac?
    url "https://github.com/shenwei356/unikmer/releases/download/v0.11.0/unikmer_darwin_amd64.tar.gz"
    sha256 "6e13d2990d6f662cea81568c9b04d2f59dd6b3679e7db56ba4c66bc73a8b1eaf"
  elsif OS.linux?
    url "https://github.com/shenwei356/unikmer/releases/download/v0.11.0/unikmer_linux_amd64.tar.gz"
    sha256 "856f55364cb7b8b6cd0380a65aa90629aa1336879daf23234e2f09d1ca62af55"
  end

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "6f557483cb5d142e707bd2fe7b570a1e65173fc752085a6f1c182868a48db63d" => :sierra
    sha256 "72b11857d78fd391aafba36b343088c486a55629bd344532e8d3e5bdb2db602e" => :x86_64_linux
  end

  def install
    bin.install "unikmer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unikmer --help 2>&1")
  end
end
