class Hyphy < Formula
  # cite Pond_2019: "https://doi.org/10.1093/molbev/msz197"
  desc "Hypothesis testing with phylogenies"
  homepage "https://www.hyphy.org/"
  url "https://github.com/veg/hyphy/archive/refs/tags/2.5.78.tar.gz"
  sha256 "06bef149fbcdfd1692f6c01e1246e99e120513a041126c5bbc4c46960a18d141"
  license "MIT"
  head "https://github.com/veg/hyphy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sequoia: "1b5deaa189abbf2639ed0df461e11fb902e76a80e9979ab81ca058cde44f377b"
    sha256 arm64_sonoma:  "3b454962b4ab62b5bef19ef7e624fdc476c8090bf247390b0fa2018bc45b0145"
    sha256 ventura:       "cb2dcdf444f6ec558b2933e2a62ba810f7dda866e322aaab91113ffffb5c64bf"
    sha256 x86_64_linux:  "9129ef53acd4c17a84360b4bbba07d84124f76604f97b664b274b61e8fccc308"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
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
