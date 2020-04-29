class Taxonkit < Formula
  desc "NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.6.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0afc6abccfda04fc09e9672a9952a73069a9d8831bd77e40b084657487b5ab83" => :sierra
    sha256 "79f1c7f5af26435d0d09a69ce52236cd9b16a30e37ba3063a78cd8117a54a9e5" => :x86_64_linux
  end

  on_linux do
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.6.0/taxonkit_linux_amd64.tar.gz"
    sha256 "0699ce1ea1c2cb69cdb2d8b5494b8217dc6389e010a0e0eacd0b191a14f21d88"
  end

  on_macos do
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.6.0/taxonkit_darwin_amd64.tar.gz"
    sha256 "462e4113d9749269799320f2de26c31aff43aae4ccd4286648410d129718da9f"
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
