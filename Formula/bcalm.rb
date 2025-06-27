class Bcalm < Formula
  # cite Chikhi_2016: "https://doi.org/10.1093/bioinformatics/btw279"
  desc "De Bruijn graph compaction in low memory"
  homepage "https://github.com/GATB/bcalm"
  url "https://github.com/GATB/bcalm.git",
      tag:      "v2.2.2",
      revision: "febf79a3b9e334962902b5f920114b7cc7e91881"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "dcc1e682e002280de1aab1401b61c6c74921ea92e9e855325546c06e5da4c7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d9e93a21a9cddaf7647a8947539d6ebbfa93c904bba36498bb9f0bf1ccdcbd28"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "bcalm"
    end
  end

  test do
    assert_match "options", shell_output("#{bin}/bcalm")
  end
end
