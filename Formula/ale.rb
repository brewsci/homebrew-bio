class Ale < Formula
  # cite Clark_2013: "https://doi.org/10.1093/bioinformatics/bts723"
  desc "Assembly Likelihood Estimator"
  homepage "https://github.com/sc932/ALE"
  url "https://github.com/sc932/ALE/archive/20130717.tar.gz"
  version "0.0.20130717"
  sha256 "fa331a4693b02c6a74a1f699ff39b83860036a9a3a7b1a4fa1effe95072c63a2"

  depends_on "zlib" unless OS.mac?

  def install
    cd "src" do
      system "make"
      bin.install "ALE", "GCcompFinder", "readFileSplitter", "synthReadGen"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ALE --help")
    assert_match "Usage", shell_output("#{bin}/GCcompFinder --help")
    assert_match "Usage", shell_output("#{bin}/readFileSplitter")
    assert_match "Usage", shell_output("#{bin}/synthReadGen --help")
  end
end
