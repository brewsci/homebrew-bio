class Unikmer < Formula
  desc "Manipulate small kmers without frequency information"
  homepage "https://github.com/shenwei356/unikmer"
  version "0.4.3"
  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fb6c13799244134cdd3147b603d49c3c3780b49e973b46af4eb32e09c551bdb4" => :sierra
    sha256 "41cb1d3c30c6dd007c85c29d139abeea7ccc6a4cb0152707ded72704ca34c082" => :x86_64_linux
  end

  if OS.mac?
    url "https://github.com/shenwei356/unikmer/releases/download/v0.4.3/unikmer_darwin_amd64.tar.gz"
    sha256 "d241b61e380cec24b86e9f779fe868b1d92cf84dbc6df61265308a0a393496a9"
  elsif OS.linux?
    url "https://github.com/shenwei356/unikmer/releases/download/v0.4.3/unikmer_linux_amd64.tar.gz"
    sha256 "fdc143c8a9146d211e2a5d47313195f68a9077b95b28c4bad437b98c402a6a7b"
  end

  def install
    bin.install "unikmer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unikmer --help 2>&1")
  end
end
