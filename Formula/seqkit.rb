class Seqkit < Formula
  # cite Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.12.1/seqkit_darwin_amd64.tar.gz"
    sha256 "abe574c62263e9ab7afe1bbb1ef94a27ebb95223205a612292585182b20e062c"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.12.1/seqkit_linux_amd64.tar.gz"
    sha256 "bee5fe0fc3589155fd1cb8bf3bd7fb39fca14cb20196e0156ef9f97800c61be6"
  end
  version "0.12.1"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "8db1cf85315bdef00469dd9a56ef57a1129ca1c83716a69065b360c7d905d8c6" => :catalina
    sha256 "676879b9162d6d5bf6d65ad3b583e14f11b6adda26e3ac5de4251285fb4c64e3" => :x86_64_linux
  end

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit version")
  end
end
