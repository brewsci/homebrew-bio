class Taxonkit < Formula
  desc "A cross-platform and efficient NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.3.0"
  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3a2a3b804a4202e023c5a2be558470069facfd2958e426cb24c6c0ed9f85e9e9" => :sierra_or_later
    sha256 "4034e0effcc01bd087d23d476ff25c5bc4f5df249c50644c727305f1d740874b" => :x86_64_linux
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
