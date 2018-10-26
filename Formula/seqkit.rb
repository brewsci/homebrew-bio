class Seqkit < Formula
  # Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/seqkit/releases/download/v0.9.1/seqkit_darwin_amd64.tar.gz"
    sha256 "7da29d43c7f21251ef7ac80bbf60ceaca566c6289e168a76b8a243c7aac419bd"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.9.1/seqkit_linux_amd64.tar.gz"
    sha256 "56fd19475f665692f5d39ba9f5d93662c964b60fa6eb0f83aed4f5890ae5243c"
  end
  version "0.9.1"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3c68a41cda7c77ab0a56c67dd2c3045f3197aca5830114a52d35268b0170517c" => :sierra
    sha256 "a08ceaee2edccc91fdf4c3aab6d388251571f63a5e81c5a3b39cc0edf536e31f" => :x86_64_linux
  end

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit 2>&1")
  end
end
