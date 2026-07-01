class Smoove < Formula
  desc "Simplified structural-variant calling with LUMPY and friends"
  homepage "https://github.com/brentp/smoove"
  url "https://github.com/brentp/smoove/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "9a96f35460952f01ca74ab58a82769ac7f8b31dba31ccba3b09dff09b0731c6f"
  license "Apache-2.0"
  head "https://github.com/brentp/smoove.git", branch: "master"

  depends_on "go" => :build
  depends_on "bcftools"
  depends_on "htslib" # bgzip, tabix
  depends_on "mosdepth"
  depends_on "samtools"

  def install
    system "go", "build", *std_go_args(output: bin/"smoove"), "./cmd/smoove"
  end

  def caveats
    <<~EOS
      smoove orchestrates several external programs. Installed as dependencies:
        bcftools, bgzip/tabix (htslib), mosdepth, samtools

      For full functionality, also install these (not packaged in this tap):
        lumpy-sv (lumpy, lumpy_filter), svtyper, gsort
      and optionally: duphold, svtools
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smoove 2>&1", 1)
  end
end
