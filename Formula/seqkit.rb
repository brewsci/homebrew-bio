class Seqkit < Formula
  # cite Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.13.0/seqkit_darwin_amd64.tar.gz"
    sha256 "4514a4a1ec73611167c64edde535d793bf70aaa3b06e0df50be9fbac621d70c3"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.13.0/seqkit_linux_amd64.tar.gz"
    sha256 "cf8ed8742ca6379a50489bc86e2c48f804455212d2be1c306c076cd79d2b832d"
  end
  version "0.13.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "b2aea4751e07b3fa48838cf9d158626db7236f363940d046e0c813e37b7bf6ba" => :catalina
    sha256 "47ca0a9444cb90101c9aea7dd9ac845be5f5aca2e98cc6ac0c039beafbe4e8d2" => :x86_64_linux
  end

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit version")
  end
end
