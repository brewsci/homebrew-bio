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
    sha256 arm64_sequoia: "03502116c383e272a488f09927b262a6fb9a1de173e8497c814d547e452ef397"
    sha256 arm64_sonoma:  "28f2100bc15f1d89338360efaa49e430488bc9c36cb9e964fb24808e9afc3b2b"
    sha256 ventura:       "678b3a93cbb816582253f56b5943811140f6a6d2c981257ed64896637518eb59"
    sha256 x86_64_linux:  "463346cbbc939ee4a2abacdb67d776169a889dad7ce55896019cb9fcf5e99334"
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
