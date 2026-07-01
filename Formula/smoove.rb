class Smoove < Formula
  desc "Simplified structural-variant calling with LUMPY and friends"
  homepage "https://github.com/brentp/smoove"
  url "https://github.com/brentp/smoove/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "9a96f35460952f01ca74ab58a82769ac7f8b31dba31ccba3b09dff09b0731c6f"
  license "Apache-2.0"
  head "https://github.com/brentp/smoove.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88c751e9c80854dbdcef89c4946fd52d3aaada4e9d144e4006fff6ced4b88514"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88c751e9c80854dbdcef89c4946fd52d3aaada4e9d144e4006fff6ced4b88514"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88c751e9c80854dbdcef89c4946fd52d3aaada4e9d144e4006fff6ced4b88514"
    sha256 cellar: :any,                 x86_64_linux:  "be6c9f92598fbfca4c30b4ff1a61a5f136d41ee5b2f6e12259fe366a84d0051a"
  end

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
