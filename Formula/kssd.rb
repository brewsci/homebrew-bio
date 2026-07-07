class Kssd < Formula
  desc "K-mer substring space sampling/shuffling decomposition"
  homepage "https://github.com/yhg926/public_kssd"
  url "https://github.com/yhg926/public_kssd/archive/refs/tags/v2.21.tar.gz"
  sha256 "2f6217b6e685dbe15c9aa4fa9a7eeb225651eb608f34799efea4ce84e2d0fd86"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ef105327189bf598e7560fd87b5ab1defab47fdd63d19fe95b41a436d6b340f1"
  end

  # https://github.com/yhg926/public_kssd/issues/2
  depends_on :linux
  depends_on "zlib"

  def install
    system "make"
    bin.install "kssd"
    pkgshare.install "test_fna"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kssd -V 2>&1")
  end
end
