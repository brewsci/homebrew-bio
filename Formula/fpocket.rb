class Fpocket < Formula
  desc "Protein pocket detection algorithm based on Voronoi tessellation"
  homepage "https://github.com/Discngine/fpocket"
  url "https://github.com/Discngine/fpocket/archive/refs/heads/master.tar.gz"
  version "4.0"
  sha256 "41d8e24bb33daaceb89a4a83ced28d86674ad16d7c8ba672169279e6c2fd68eb"
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
