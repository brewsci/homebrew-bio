class Seqkit < Formula
  # Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.9.3/seqkit_darwin_amd64.tar.gz"
    sha256 "75eaee8b88d01d5a0bcc6189564769319b668bbaa36f9b9f2435ba3096caf746"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.9.3/seqkit_linux_amd64.tar.gz"
    sha256 "e00bc5002fdb296860f43405409aacffc499b7a9da9ed4eecb2cdabfcd249af5"
  end
  version "0.9.3"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e92e00ba831f543f713cb49f8efaf166f47e047518f9f7b6ff5b1812253a8004" => :sierra
    sha256 "f7e0e598c589334c88ec16199841c97f252639020358af9cd75d98b3bea956f1" => :x86_64_linux
  end

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit 2>&1")
  end
end
