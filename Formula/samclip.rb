class Samclip < Formula
  desc "Filter soft/hard clipped alignments from SAM files"
  homepage "https://github.com/tseemann/samclip"
  url "https://github.com/tseemann/samclip/archive/v0.2.tar.gz"
  sha256 "70cf12ec758d5c43fb98dedb9dba0649a851338b19e2290a55288cbf498b6a67"

  def install
    bin.install "samclip"
    pkgshare.install Dir["test.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/samclip --version")
    t = pkgshare/"test"
    assert_match "Done.",
      shell_output("#{bin}/samclip --ref #{t}.fna < #{t}.sam 2>&1 > /dev/null")
  end
end
