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
    sha256 "741feef9e75df707b1af3123a1acbae39a7bebeabb3c89159537e5528e221e33" => :sierra
    sha256 "0a0371893365cf4a6a493eab9d367f054e2e63a1cf5e1d010cf1d4c3a17dba47" => :x86_64_linux
  end

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit 2>&1")
  end
end
