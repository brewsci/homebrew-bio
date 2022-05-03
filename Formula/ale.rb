class Ale < Formula
  # cite Clark_2013: "https://doi.org/10.1093/bioinformatics/bts723"
  desc "Assembly Likelihood Estimator"
  homepage "https://github.com/sc932/ALE"
  url "https://github.com/sc932/ALE/archive/20220503.tar.gz"
  sha256 "b04a047fd3b11c0e84718bea20fe7d03f50f80a542d3b18e66c5b95983b9e559"
  head "https://github.com/sc932/ALE.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "78ac2d51e396bd5225c2887f7198074aba2f4de6be5d8f67e9d94f7bdd6981ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8d003ad08edfe031ce31d0305a901bcb3dcda4c8d3b7f6a31b4cd6c27a385587"
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
