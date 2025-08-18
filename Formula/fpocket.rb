class Fpocket < Formula
  desc "Protein pocket detection algorithm based on Voronoi tessellation"
  homepage "https://github.com/Discngine/fpocket"
  url "https://github.com/Discngine/fpocket/archive/refs/tags/4.2.2.tar.gz"
  sha256 "4042125e7243e03465200bee787e55a54c16c1a10908718af75275c46bfafaad"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "80018eb3725cf7c60387fa1a26d28250511b7501321e446af21c95de8b0dca04"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2f1b7d8467acb1970ca0ac8b657b18e04a88681f23990a50b56334e35111c972"
  end

  depends_on "netcdf"

  def install
    arch = if OS.mac? && Hardware::CPU.arm?
      "ARCH=MACOSXARM64"
    elsif OS.mac? && Hardware::CPU.intel?
      "ARCH=MACOSXX86_64"
    else
      "ARCH=LINUX"
    end
    system "make", arch
    bin.install Dir["bin/*pocket"]
  end

  test do
    assert_match "***** POCKET HUNTING BEGINS *****", shell_output("#{bin}/fpocket")
  end
end
