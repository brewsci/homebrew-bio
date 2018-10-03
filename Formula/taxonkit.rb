class Taxonkit < Formula
  desc "Cross-platform and efficient NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.2.5"
  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3a2a3b804a4202e023c5a2be558470069facfd2958e426cb24c6c0ed9f85e9e9" => :sierra_or_later
    sha256 "4034e0effcc01bd087d23d476ff25c5bc4f5df249c50644c727305f1d740874b" => :x86_64_linux
  end

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.2.5-dev3/taxonkit_darwin_amd64.tar.gz"
    sha256 "d0b1f4354a42a998515a380c7b650aa94d1a5b7cc6fc124a87602a6f0f6b190d"
  elsif OS.linux?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.2.5-dev3/taxonkit_linux_amd64.tar.gz"
    sha256 "2a48f8bbe8bb12ad985bc0fb1273c88cf322f0016b4e068f9dd006d4b7a4a8d2"
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
