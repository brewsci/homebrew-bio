class Samclip < Formula
  desc "Filter soft/hard clipped alignments from SAM files"
  homepage "https://github.com/tseemann/samclip"
  url "https://github.com/tseemann/samclip/archive/v0.4.0.tar.gz"
  sha256 "8196b705b0319b168949f42818eb3a6bcf96119a24daa950fa0d908d3111d127"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2067909340da4ba5782af14b1c009396effdc53efd14b54e02458a3bd7387566" => :catalina
    sha256 "ed81eb05cd406556e8805a63ed5d2a9223f034626422548e6fa43ef11c463e36" => :x86_64_linux
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
