class Seqkit < Formula
  # cite Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v2.0.0/seqkit_darwin_amd64.tar.gz"
    sha256 "90c888062857adf70f39e682ee41f2bd0bdc94081fd47573d8336be73cc4dbbf"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v2.0.0/seqkit_linux_amd64.tar.gz"
    sha256 "6d34ad536a20ca7acfd2303e0f520173a9c85d81b3629e74d946b2530264242b"
  end
  version "2.0.0"
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
