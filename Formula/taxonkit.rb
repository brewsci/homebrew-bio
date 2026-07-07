class Taxonkit < Formula
  desc "NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.20.0"
  license "MIT"

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.20.0/taxonkit_darwin_amd64.tar.gz"
    sha256 "9afd16c472b1337cf7651f37cbc9fd1e94861169999872163bafabf166171960"
  else
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.20.0/taxonkit_linux_amd64.tar.gz"
    sha256 "d801ea82f9e516a9f0ccecf72a8212809677b8742fb9528d407fbfca8811a553"
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "b5156f92a6bfef4a9353271fd8f35019bf42439ce8bf2164738bf6d8e1f03c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e1a59f86c2807be540d54c8241ab627409d21fc6d6cedd0de05c524358668506"
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
