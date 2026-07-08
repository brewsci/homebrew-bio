class Pilon < Formula
  desc "Improve draft assemblies and find variation"
  homepage "https://github.com/broadinstitute/pilon/wiki"
  url "https://github.com/broadinstitute/pilon/releases/download/v1.24/pilon-1.24.jar"
  sha256 "ea8e7ca8669887ebe1c376bef440ba487377d4802a45c5937ed37c49cafb8df6"
  head "https://github.com/broadinstitute/pilon.git", branch: "master"
  # cite Walker_2014: "https://doi.org/10.1371/journal.pone.0112963"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47c10c0dfbc7fa5fe3b346bc073a1fa00f60c00a1469feb0b6799b600310b464"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47c10c0dfbc7fa5fe3b346bc073a1fa00f60c00a1469feb0b6799b600310b464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47c10c0dfbc7fa5fe3b346bc073a1fa00f60c00a1469feb0b6799b600310b464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67870c075071e5a7657aba2a3fa38fd3b83a0b39b9c58aea2d3f1b1ea4d714ba"
  end

  depends_on "openjdk"

  def install
    opts = "-Xmx1000m -Xms20m"
    jar = "pilon-#{version}.jar"
    prefix.install jar
    bin.write_jar_script prefix/jar, "pilon", opts
  end

  test do
    assert_match "Usage", shell_output("#{bin}/pilon --help")
  end
end
