class Skesa < Formula
  desc "Strategic Kmer Extension for Scrupulous Assemblies"
  homepage "https://ftp.ncbi.nlm.nih.gov/pub/agarwala/skesa/"

  url "https://ftp.ncbi.nlm.nih.gov/pub/agarwala/skesa/skesa.static"
  # version number is 2.0 but subversion is only visible with --version
  version "2.0.551987"
  sha256 "82d9b0c06eb50ce9baff1a7b1d5a7a18e5a4ed7009f22a1e80a3ca6fdc70429c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "59fb2540d2b5c6a3a6e354ea349eb03054797179aa2a9c2447ed7bd282ac4ab7" => :x86_64_linux
  end

  depends_on :linux

  resource "readme" do
    url "https://ftp.ncbi.nlm.nih.gov/pub/agarwala/skesa/README.skesa"
    sha256 "a576a9739799692524c635dab9fda39ddec391f4aec51877224b36f27f984c22"
  end

  def install
    bin.install "skesa.static" => "skesa"
    doc.install resource("readme")
  end

  test do
    assert_match "SKESA", shell_output("#{bin}/skesa --version 2>&1")
  end
end
