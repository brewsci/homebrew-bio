class Kssd < Formula
  desc "K-mer substring space sampling/shuffling decomposition"
  homepage "https://github.com/yhg926/public_kssd"
  url "https://github.com/yhg926/public_kssd/archive/v1.0.tar.gz"
  sha256 "a5dcaf520049a962bef625cb59a567ea2b4252d4dc9be28dd06123d340e03919"

  # https://github.com/yhg926/public_kssd/issues/2
  depends_on :linux
  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "kssd"
    pkgshare.install "test_fna"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kssd -V 2>&1")
  end
end
