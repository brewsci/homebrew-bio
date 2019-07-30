class Seqkit < Formula
  # Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.10.2/seqkit_darwin_amd64.tar.gz"
    sha256 "bb6d8a5a3c83cb4601dcd7d2c95cbec6e9b63922837bae9be4909b3fe7cdbe98"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.10.2/seqkit_linux_amd64.tar.gz"
    sha256 "cdd31667ebfe2fd35c64492066a6d867419bab6dc16ead85129a0816116fe348"
  end
  version "0.10.2"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "abe8af6d05a55edcef47ec4444c6b9456f6ff8d4d613bf43c2449788e3f8e1f3" => :sierra
    sha256 "10df2fe48f4699de48c1f05e4e56c572e9f9b0610e60ebe4c9bb885555213ed7" => :x86_64_linux
  end

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit 2>&1")
  end
end
