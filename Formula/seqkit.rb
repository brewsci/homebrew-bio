class Seqkit < Formula
  # cite Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.14.0/seqkit_darwin_amd64.tar.gz"
    sha256 "1e3806b2e6f7600d78ba218733e4d46a2a6282414ff34f404b210d60a280dd9e"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.14.0/seqkit_linux_amd64.tar.gz"
    sha256 "77e6dcbd7b00100f32efa7410bb00700576cfc7ceec69c8ab4b378f584d4e9c6"
  end
  version "0.14.0"
  license "MIT"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "48b2bcd5bb7e30f810aa517eef0d357391b968eb3120baff42a02f6c3432a18c" => :catalina
    sha256 "2b311ca6b3a6f5febf6baeafcefd6524d05de38c3bf0eaa26b32472c8f51ad92" => :x86_64_linux
  end

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit version")
  end
end
