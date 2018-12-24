class Seqkit < Formula
  # Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.10.0/seqkit_darwin_amd64.tar.gz"
    sha256 "73d446b961d65e814bdad49f91aa9ae56bee08163800eb9e3615b5281972d458"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.10.0/seqkit_linux_amd64.tar.gz"
    sha256 "4d286e08df697ab0e66e79b7b953f52361afd14855be4905193833746da47798"
  end
  version "0.10.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "59b924c9e5f33fc2831aa5b4846ed3711da83ef9d65a90c0ac0f48f23a1dde27" => :sierra
    sha256 "0311b0302e41ab0d58fccb7e5bb69ff83999e0ea889ac989e07c29af9410ed3a" => :x86_64_linux
  end

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit 2>&1")
  end
end
