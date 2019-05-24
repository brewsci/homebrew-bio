class BwaMem2 < Formula
  desc "The next version of bwa-mem short read aligner"
  homepage "https://github.com/bwa-mem2/bwa-mem2"
  url "https://github.com/bwa-mem2/bwa-mem2/archive/v2.0pre1.tar.gz"
  sha256 "8193517da7ca51b77a20508dff1c33879bf66d00a1f2d84236fca8788018fbe1"

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "bwa-mem2"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bwa-mem2 version 2>&1")
  end
end
