class Taxonkit < Formula
  desc "A cross-platform and efficient NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.3.0"
  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "52bc0f2bbd2286f5e4394e22c232851435f3b3b5d43834dd4f0bb5c362045569" => :sierra
    sha256 "57b2f2b8c6601ed954bbbfdba1c10fc54da88054bde8ff88a99b4f99e77d981b" => :x86_64_linux
  end

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.3.0/taxonkit_darwin_amd64.tar.gz"
    sha256 "b6cabc477f5fcf41419b6998a06cfae90d6627eb7177637955b7769f3ecdda7d"
  elsif OS.linux?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.3.0/taxonkit_linux_amd64.tar.gz"
    sha256 "c386e04026c5982639fdf4870b70d96c0da53c9252aeccd71b26a8a7ec5a6cc1"
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
