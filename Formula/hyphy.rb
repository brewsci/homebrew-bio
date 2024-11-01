class Hyphy < Formula
  # cite Pond_2019: "https://doi.org/10.1093/molbev/msz197"
  desc "Hypothesis testing with phylogenies"
  homepage "https://www.hyphy.org/"
  url "https://github.com/veg/hyphy/archive/refs/tags/2.5.63.tar.gz"
  sha256 "86a94a601fa136443a8cd69f61e3a47b1dc85f10743d317715b1e433278e9ee0"
  license "MIT"
  head "https://github.com/veg/hyphy.git", branch: "master"

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
      system "make", "MP", "HYPHYMPI"
      system "make", "install"
    end
  end

  test do
    assert_match "usage: hyphy or HYPHYMPI", shell_output("#{bin}/hyphy --help 2>&1")
    assert_match "usage: hyphy or HYPHYMPI", shell_output("#{bin}/HYPHYMPI --help 2>&1")
  end
end
