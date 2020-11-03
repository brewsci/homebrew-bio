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
    sha256 "8d884f4bbba6e7962b835cf50c4b08d5a7f8262b5ac47a2f774cfae0e4772dd7" => :catalina
    sha256 "22b6a81fd7d5de9d3f59826d886b24d139a24f83aaaaefe8e4b91f54a6928483" => :x86_64_linux
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
