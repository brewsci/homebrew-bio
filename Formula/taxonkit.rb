class Taxonkit < Formula
  desc "Cross-platform and efficient NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.2.5-stable"
  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3a2a3b804a4202e023c5a2be558470069facfd2958e426cb24c6c0ed9f85e9e9" => :sierra_or_later
    sha256 "4034e0effcc01bd087d23d476ff25c5bc4f5df249c50644c727305f1d740874b" => :x86_64_linux
  end

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.2.5/taxonkit_darwin_amd64.tar.gz"
    sha256 "ac2b786655c6a5233c9b6930332da48907a525733c80fc33295a763fff92e97e"
  elsif OS.linux?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.2.5/taxonkit_linux_amd64.tar.gz"
    sha256 "1e6f7d0c6a86718382b6f8438189c0f18201a52f65ec18100ae98a1d2944b42e"
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
