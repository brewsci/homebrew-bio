class Unikmer < Formula
  desc "Manipulate small kmers without frequency information"
  homepage "https://github.com/shenwei356/unikmer"
  version "0.11.0"
  license "MIT"
  if OS.mac?
    url "https://github.com/shenwei356/unikmer/releases/download/v0.11.0/unikmer_darwin_amd64.tar.gz"
    sha256 "6e13d2990d6f662cea81568c9b04d2f59dd6b3679e7db56ba4c66bc73a8b1eaf"
  elsif OS.linux?
    url "https://github.com/shenwei356/unikmer/releases/download/v0.11.0/unikmer_linux_amd64.tar.gz"
    sha256 "856f55364cb7b8b6cd0380a65aa90629aa1336879daf23234e2f09d1ca62af55"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0db8530f9dc5c2b16a71595d69f7fca624225f70bf4c8f67575c3bfd31ecd57b" => :catalina
    sha256 "1c911f2be23033c8cb4d494e5f67bdfe5394d5a92cf01848f518c8343134a73a" => :x86_64_linux
  end

  def install
    bin.install "unikmer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unikmer --help 2>&1")
  end
end
