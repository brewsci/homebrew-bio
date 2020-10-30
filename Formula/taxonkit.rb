class Taxonkit < Formula
  desc "NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.6.1"
  license "MIT"

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.6.1/taxonkit_darwin_amd64.tar.gz"
    sha256 "a564d8065f31f0376023056f97d04e2d76418d7f525535298b434a29cbce80bf"
  else
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.6.1/taxonkit_linux_amd64.tar.gz"
    sha256 "67feff2a4127217f2673cf30f44b09d30e1ce67755f47df7a4e3509b8051e1ab"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "365c36072b1574851918593780efbcc8d9cb3fa5773e0720b66aa1edd7c26fd8" => :catalina
    sha256 "2cf8a967879c0768e6fcc132470ba5ae0897576828f1364724d52028dde43d1c" => :x86_64_linux
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
