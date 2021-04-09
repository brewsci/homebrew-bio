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
    sha256 cellar: :any_skip_relocation, catalina:     "5a8008fd08f9a3f128a5c4587e1ac74a6a1e6051ba68219519e95090560020de"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5993c7abb48fa449d40b99ba221df7490f7d795f2230a86f2ea0a0dcb6d2f59b"
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
