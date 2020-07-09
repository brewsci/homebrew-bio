class Kssd < Formula
  desc "K-mer substring space sampling/shuffling decomposition"
  homepage "https://github.com/yhg926/public_kssd"
  url "https://github.com/yhg926/public_kssd/archive/v1.1.tar.gz"
  sha256 "bdf42a9a280126c41736aa9ee480d2948e32f9027e97607fe18473db59187bf4"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
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
