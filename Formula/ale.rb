class Ale < Formula
  # cite Clark_2013: "https://doi.org/10.1093/bioinformatics/bts723"
  desc "Assembly Likelihood Estimator"
  homepage "https://github.com/sc932/ALE"
  url "https://github.com/sc932/ALE/archive/20180904.tar.gz"
  version "0.0.20180904"
  sha256 "123457834c173f10710a0b4c2fcefd8c6fa62af11f6ad311f199c242c49e8f68"
  head "https://github.com/sc932/ALE.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "78ac2d51e396bd5225c2887f7198074aba2f4de6be5d8f67e9d94f7bdd6981ff" => :sierra
    sha256 "8d003ad08edfe031ce31d0305a901bcb3dcda4c8d3b7f6a31b4cd6c27a385587" => :x86_64_linux
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
