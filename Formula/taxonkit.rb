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
    sha256 "1003d7128892ceb220db276f3ff63f39df885282c297aaba0661150f4896b6a8" => :catalina
    sha256 "08741bc649f65882a787119ca61eb53db8ad6da4ad8a03e86664e1ce6d62af65" => :x86_64_linux
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
