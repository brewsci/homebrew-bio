class Taxonkit < Formula
  desc "NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.6.2"
  license "MIT"

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.6.2/taxonkit_darwin_amd64.tar.gz"
    sha256 "a4b6a36fd9c174a6a29469d8e9d66ccd9f1e0dc0e1a12a446c6dc838bc02cd2a"
  else
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.6.2/taxonkit_linux_amd64.tar.gz"
    sha256 "88b37f35f939be2ab81156e40ddc850290a079251d7b3d807419025235d9084e"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f5814d4e3cae59394e992dd21c40ec6308180b553cff15a1cebac7a098bc2909" => :catalina
    sha256 "cc6068bc475a7424a5d1d816e557a84e18413f17a9165999483aff5605e8cd9f" => :x86_64_linux
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
