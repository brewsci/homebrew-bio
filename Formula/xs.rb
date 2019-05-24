class Xs < Formula
  desc "FASTQ read simulation tool"
  homepage "https://github.com/pratas/xs"
  url "https://github.com/pratas/xs/archive/v2.tar.gz"
  sha256 "3882f88dd757bee2d44cf2393af02084c572dd490dd8cbe55925cb2788777174"

  def install
    system "make"
    bin.install "XS"
  end

  test do
    # Wrong exit code: https://github.com/pratas/xs/issues/6
    assert_match "FASTQ", shell_output("#{bin}/XS -h 2>&1", 1)
  end
end
