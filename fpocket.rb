class Fpocket < Formula
  desc "Protein pocket detection algorithm based on Voronoi tessellation"
  homepage "https://github.com/Discngine/fpocket"
  url "https://github.com/Discngine/fpocket/archive/refs/heads/master.tar.gz"
  version "4.0"
  sha256 "8ee461ca1f47f316de9c690340dd2e8ef488914fca7c97225ab21b35bfb160f6"
  license "MIT"

  depends_on "netcdf"

  def install
    system "make", "ARCH=MACOSXX86_64"
    bin.install Dir["bin/*pocket"]
  end

  test do
    system "python", "-m", "pip", "install", "pytest"
    system "pytest", "tests/"
  end
end

