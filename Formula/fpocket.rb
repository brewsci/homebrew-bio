class Fpocket < Formula
  desc "Protein pocket detection algorithm based on Voronoi tessellation"
  homepage "https://github.com/Discngine/fpocket"
  url "https://github.com/Discngine/fpocket/archive/refs/tags/4.0.0.tar.gz"
  sha256 "97b808b233b0fc314fe5e32c9cc8cc7d4377b53aba36807a5554a180f13524c0"
  license "MIT"

  depends_on "netcdf"
  depends_on "qhull"

  def install
    system "make" if OS.linux?
    system "make", "ARCH=MACOSXX86_64" if OS.mac?
    bin.install Dir["bin/*pocket"]
  end

  test do
    assert_match "***** POCKET HUNTING BEGINS *****", shell_output("#{bin}/fpocket")
  end
end
