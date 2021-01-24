class Taxonkit < Formula
  desc "NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.7.1"
  license "MIT"

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.7.1/taxonkit_darwin_amd64.tar.gz"
    sha256 "f2ae7061bceff45db528d55f3f30e43a90d8f25666aabd6adc799ca4d4b90445"
  else
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.7.1/taxonkit_linux_amd64.tar.gz"
    sha256 "72f77c6e38690aa730078f3ede12daa65ca83d595c1c2a15add8b1a80f229810"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "4fffd2577fdfa919527f9809ad2cd9df282f4b7478f8f59609795118d4bb3760" => :catalina
    sha256 "1daf3375212b879b155ba096e5d5cede503591692bbdc9f90d68a268a36e8371" => :x86_64_linux
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
