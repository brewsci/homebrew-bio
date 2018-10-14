class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit"
  homepage "https://bioinf.shenwei.me/csvtk/"
  # We use binaries to avoid compiling Go code
  if OS.mac?
    url "https://github.com/shenwei356/csvtk/releases/download/v0.15.0/csvtk_darwin_amd64.tar.gz"
    sha256 "f867151e2b9e6b6c4d5fb1c8df5812282f741e79ee638796efcf117460f10b0c"
  else
    url "https://github.com/shenwei356/csvtk/releases/download/v0.15.0/csvtk_linux_amd64.tar.gz"
    sha256 "1e2ec19dac32b7fe56042a929369c6a595a40811191bd4788f802597708195ef"
  end
  version "0.15.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3c68a41cda7c77ab0a56c67dd2c3045f3197aca5830114a52d35268b0170517c" => :sierra_or_later
    sha256 "a08ceaee2edccc91fdf4c3aab6d388251571f63a5e81c5a3b39cc0edf536e31f" => :x86_64_linux
  end

  def install
    bin.install "csvtk"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/csvtk 2>&1")
  end
end
