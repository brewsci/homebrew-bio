class Ale < Formula
  # cite Clark_2013: "https://doi.org/10.1093/bioinformatics/bts723"
  desc "Assembly Likelihood Estimator"
  homepage "https://github.com/sc932/ALE"
  url "https://github.com/sc932/ALE/archive/20220503.tar.gz"
  sha256 "b04a047fd3b11c0e84718bea20fe7d03f50f80a542d3b18e66c5b95983b9e559"
  head "https://github.com/sc932/ALE.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, big_sur:      "fc74edfce72237bd489075d20a267f45a818e45a2db4123bf02db9351d060406"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "13876fb6d4410929cdcb5ee55945372898905c86ae01eccc4394507a8e67205b"
  end

  uses_from_macos "zlib"

  def install
    cd "src" do
      system "make"
      system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ALE --help")
    assert_match "Usage", shell_output("#{bin}/GCcompFinder --help")
    assert_match "Usage", shell_output("#{bin}/readFileSplitter")
    assert_match "Usage", shell_output("#{bin}/synthReadGen --help")
  end
end
