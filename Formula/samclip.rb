class Samclip < Formula
  desc "Filter soft/hard clipped alignments from SAM files"
  homepage "https://github.com/tseemann/samclip"
  url "https://github.com/tseemann/samclip/archive/v0.3.0.tar.gz"
  sha256 "d52eb2ce84aed17c72d7f1cde035cddd8f66a45fd748c2325c912a8fc6225889"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "27aaa324ee836bd37a6aeb51c79f6e2bdbe7fd5bb41a63a2887b21cdfcc76de8" => :sierra
    sha256 "5f34d02a47fd1cdc30f4629cdb1c674a5eed3335984406b0ae48f26476d50297" => :x86_64_linux
  end

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
