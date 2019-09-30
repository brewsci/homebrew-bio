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
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fb6c13799244134cdd3147b603d49c3c3780b49e973b46af4eb32e09c551bdb4" => :sierra
    sha256 "41cb1d3c30c6dd007c85c29d139abeea7ccc6a4cb0152707ded72704ca34c082" => :x86_64_linux
  end

  def install
    bin.install "unikmer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unikmer --help 2>&1")
  end
end
