class Taxonkit < Formula
  desc "NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.8.0"
  license "MIT"

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.8.0/taxonkit_darwin_amd64.tar.gz"
    sha256 "485014a58fc73c884fbe66eab1a99854f17b2ec52fed0905bf3b32cbc369fdc4"
  else
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.8.0/taxonkit_linux_amd64.tar.gz"
    sha256 "a88c69f00c3d79520a0ee86df21164b7221003f636ac76681821a542696dff1d"
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
