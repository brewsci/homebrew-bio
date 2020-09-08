class Taxonkit < Formula
  desc "NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.6.0"
  license "MIT"

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.6.0/taxonkit_darwin_amd64.tar.gz"
    sha256 "462e4113d9749269799320f2de26c31aff43aae4ccd4286648410d129718da9f"
  else
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.6.0/taxonkit_linux_amd64.tar.gz"
    sha256 "0699ce1ea1c2cb69cdb2d8b5494b8217dc6389e010a0e0eacd0b191a14f21d88"
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
