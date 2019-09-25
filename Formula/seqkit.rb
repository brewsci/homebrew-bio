class Seqkit < Formula
  # cite Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.11.0/seqkit_darwin_amd64.tar.gz"
    sha256 "81887364466bd50991b7ef7535b843e2398eb3371362c4cc8794cda0621797be"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.11.0/seqkit_linux_amd64.tar.gz"
    sha256 "1e4e93d5521a109551f64176fb7c9b1445497ab14d1bbee42a7c6b5c4530749b"
  end
  version "0.11.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2e97c8f8c443fe3f6e6be7a11102e1dde6ae764cd9c1878041ba5e842a508cab" => :sierra
    sha256 "1e48c929a711a86852decc75a35dc09dd5fda4bf50a73543db738a771e12c5d1" => :x86_64_linux
  end

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit version")
  end
end
