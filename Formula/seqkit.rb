class Seqkit < Formula
  # Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.7.2/seqkit_darwin_amd64.tar.gz"
    sha256 "6b34e400e9d0437516743b18ffa57b940f2f66ca98b40f4c52562fc2a7ce50f9"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.7.2/seqkit_linux_amd64.tar.gz"
    sha256 "de75151fc93ee24717370f9d54aff2f76a04be14ae2dd9384d749b060c210124"
  end
  version "0.7.2"

  depends_on "pigz"

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit 2>&1")
  end
end
