class Seqkit < Formula
  # cite Shen_2016: "https://doi.org/10.1371/journal.pone.0163962"
  desc "Ultrafast FASTA/Q file manipulation"
  homepage "https://bioinf.shenwei.me/seqkit/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
<<<<<<< HEAD
    url "https://github.com/shenwei356/seqkit/releases/download/v0.12.1/seqkit_darwin_amd64.tar.gz"
    sha256 "abe574c62263e9ab7afe1bbb1ef94a27ebb95223205a612292585182b20e062c"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.12.1/seqkit_linux_amd64.tar.gz"
    sha256 "bee5fe0fc3589155fd1cb8bf3bd7fb39fca14cb20196e0156ef9f97800c61be6"
  end
  version "0.12.1"
=======
    url "https://github.com/shenwei356/seqkit/releases/download/v0.13.2/seqkit_darwin_amd64.tar.gz"
    sha256 "1c5c4f5224e1c584ed944dc0d4da879124bb267c2f0805a1f623f4fe1920c744"
  else
    url "https://github.com/shenwei356/seqkit/releases/download/v0.13.2/seqkit_linux_amd64.tar.gz"
    sha256 "53703542d44a5e758eaf34b55d18f70cfe23e9b5b78fd7c1c0202dee9a65bed0"
  end
  version "0.13.2"
  license "MIT"
>>>>>>> upstream/develop

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
<<<<<<< HEAD
    sha256 "c11313deaa1b164708aa1281dd7ad9ae1e756a31a4e4ca986a0ab6501546bc7b" => :catalina
    sha256 "b57ac08b9dca7898e6a791a1f9a9a1c45eb03aaab5a7783dfd9472a672b23157" => :x86_64_linux
=======
    sha256 "ebfc70d323aa3ed82d0ae46c5665ae8125db73e769b4f35e721366f87403e7d0" => :catalina
    sha256 "8f008246e91a161695d78589115e9166d628778ca21772dff3b449d230ecf1b1" => :x86_64_linux
>>>>>>> upstream/develop
  end

  def install
    bin.install "seqkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit version")
  end
end
