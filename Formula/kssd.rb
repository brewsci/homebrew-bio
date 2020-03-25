class Kssd < Formula
  desc "K-mer substring space sampling/shuffling decomposition"
  homepage "https://github.com/yhg926/public_kssd"
  url "https://github.com/yhg926/public_kssd/archive/v1.0.tar.gz"
  sha256 "a5dcaf520049a962bef625cb59a567ea2b4252d4dc9be28dd06123d340e03919"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e4932583d638612e52e7091f8ad31201aee0a6f0540c7fd6a09bc1698d963c32" => :x86_64_linux
  end

  # https://github.com/yhg926/public_kssd/issues/2
  depends_on :linux

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "kssd"
    pkgshare.install "test_fna"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kssd -V 2>&1")
  end
end
