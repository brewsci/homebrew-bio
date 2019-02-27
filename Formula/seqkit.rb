class Seqkit < Formula
  # Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.10.1/seqkit_darwin_amd64.tar.gz"
    sha256 "5b94955e26edb35a0077e00b1d4a2362674f0a3ff253118a0be3ce9749f84ed2"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.10.1/seqkit_linux_amd64.tar.gz"
    sha256 "82f1c86dc4bd196403a56c2bf3ec063e5674a71777e68d940c4cc3d8411d2e9d"
  end
  version "0.10.1"

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
