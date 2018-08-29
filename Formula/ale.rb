class Ale < Formula
  # cite Clark_2013: "https://doi.org/10.1093/bioinformatics/bts723"
  desc "Assembly Likelihood Estimator"
  homepage "https://github.com/sc932/ALE"
  url "https://github.com/sc932/ALE/archive/4aec46e0a544680edd8ec638d25bdf825b9d3b56.tar.gz"
  version "0.0.20171221"
  sha256 "47daa42bd1ae3ea915ee3fa2f6409eb01c5a9dffc185407a892e9a9010fefc6d"
  head "https://github.com/sc932/ALE.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0b4ca1437ab82ddc666eb666abd71839ae716b3fd8d3c0599cd2e7b77c8c53df" => :sierra_or_later
    sha256 "c94cba3e6b7ee8892c110021bb2bb5ffe351383fee795e0095ea3c9099b408bb" => :x86_64_linux
  end

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
