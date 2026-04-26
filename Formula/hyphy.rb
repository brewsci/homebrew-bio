class Hyphy < Formula
  # cite Pond_2019: "https://doi.org/10.1093/molbev/msz197"
  desc "Hypothesis testing with phylogenies"
  homepage "https://www.hyphy.org/"
  url "https://github.com/veg/hyphy/archive/refs/tags/2.5.97.tar.gz"
  sha256 "88461597630b9cbc9ec7c0ebbd3cd5c7035d00fec5394d02821bfb2b4b4b087e"
  license "MIT"
  head "https://github.com/veg/hyphy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_tahoe:   "bf29b61c2681dff726f2b69babc9a86d5f53c042a6f2b347c84842e85a05437c"
    sha256 arm64_sequoia: "461b1baa21e25bc16f2a36e677bcbd0996dcde9c618897127250ba3aa5fafaa1"
    sha256 arm64_sonoma:  "0e3316228d6f115e19122d9889646c32f2cdd5a4db16c8e65e9674d09840f650"
    sha256 x86_64_linux:  "9e0f6925c42f4c6fe850fbfef6d53616d822b88c288b59b2c1546bc41ba0086f"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    cd "build" do
      system "make", "hyphy", "HYPHYMPI"
      system "make", "install"
    end
  end

  test do
    assert_match "usage: hyphy or HYPHYMPI", shell_output("#{bin}/hyphy --help 2>&1")
    assert_match "usage: hyphy or HYPHYMPI", shell_output("#{bin}/HYPHYMPI --help 2>&1")
  end
end
