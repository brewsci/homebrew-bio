class Seqkit < Formula
  # cite Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.15.0/seqkit_darwin_amd64.tar.gz"
    sha256 "5428cf6e2d04efd0adc0fa045a3f90fd37c34235630be2819aef0de25901f12a"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.15.0/seqkit_linux_amd64.tar.gz"
    sha256 "bf305e7d5b4fbe14a6e87ebf6aa454117dd3cf030cb9473d01161c0a1987a182"
  end
  version "0.15.0"
  license "MIT"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
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
