class Seqkit < Formula
  # cite Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.12.0/seqkit_darwin_amd64.tar.gz"
    sha256 "ed52365c9b10347c345124bb8f1c37ac1fc6b2a918223be3755ed5ffc3b1c788"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.12.0/seqkit_linux_amd64.tar.gz"
    sha256 "7d8a044fc07fce9f1af8e486df38500309cf68dd872b90e7404e184674cb5733"
  end
  version "0.12.0"

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
