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
    sha256 cellar: :any_skip_relocation, catalina:     "d93ab217d4c07aa96ee4493cb6823ba15876a0b7ec4701533610324754da0e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8c0c32149e8b91d2b4e0bbfefd9e786e7e34566754fb5872236b1789777ef9af"
  end

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit version")
  end
end
