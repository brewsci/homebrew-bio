class Unikmer < Formula
  desc "Manipulate small kmers without frequency information"
  homepage "https://github.com/shenwei356/unikmer"
  version "0.7.0"
  if OS.mac?
    url "https://github.com/shenwei356/unikmer/releases/download/v0.7.0/unikmer_darwin_amd64.tar.gz"
    sha256 "c21d3cf2c87689738ecee883d6abdbf33cd4d04fe17981e4749966c427b2b0a0"
  elsif OS.linux?
    url "https://github.com/shenwei356/unikmer/releases/download/v0.7.0/unikmer_linux_amd64.tar.gz"
    sha256 "2a734b34632c3b548107742e9c7bdeb7da8fbc4f8f4d1598e32fc38c37fcdc81"
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
