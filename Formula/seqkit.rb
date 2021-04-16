class Seqkit < Formula
  # cite Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.16.0/seqkit_darwin_amd64.tar.gz"
    sha256 "44376dabce69c71fe79d2ace91e49ff145c54046a34b23386c92eb574fe42dbe"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.16.0/seqkit_linux_amd64.tar.gz"
    sha256 "fb59aaf7c4fcb74b61dfaab8bbdcad47333b98040c2a1408974786619e686c66"
  end
  version "0.16.0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "831fc5b89602adc8cfaa943c40522a345a020d3487b5d06b89d3aaf36a9e408b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4f3585065b3098939f201c2b081a0539ef59ffadfa8b162f8c0b471849483296"
  end

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit version")
  end
end
