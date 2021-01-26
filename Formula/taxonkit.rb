class Taxonkit < Formula
  desc "NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.7.2"
  license "MIT"

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.7.2/taxonkit_darwin_amd64.tar.gz"
    sha256 "f83591c3260862508faf1db57a148e884518ddc8b381872787f240c47c057a88"
  else
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.7.2/taxonkit_linux_amd64.tar.gz"
    sha256 "67eef3bb007d88dd0fd89a9108555d74ec32a5ef0f550d9c38d7860065bfc67e"
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
