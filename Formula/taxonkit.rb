class Taxonkit < Formula
  desc "NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.7.2"
  license "MIT"

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.7.2/taxonkit_darwin_amd64.tar.gz"
    sha256 "f83591c3260862508faf1db57a148e884518ddc8b381872787f240c47c057a88"
  else
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.7.2/taxonkit_linux_amd64.tar.gz"
    sha256 "67eef3bb007d88dd0fd89a9108555d74ec32a5ef0f550d9c38d7860065bfc67e"
  end

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
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
