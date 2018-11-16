class Seqkit < Formula
  # Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.9.2/seqkit_darwin_amd64.tar.gz"
    sha256 "0cc787422020e9382d55ab29601a26f0843b6ea7d73818e66e949137cea02982"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.9.2/seqkit_linux_amd64.tar.gz"
    sha256 "72b61ad030290da7b6a133d6b78927dfc196c339f2a7673d45bc8c92505dd000"
  end
  version "0.9.2"

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
