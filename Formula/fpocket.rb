class Fpocket < Formula
  desc "Protein pocket detection algorithm based on Voronoi tessellation"
  homepage "https://github.com/Discngine/fpocket"
  url "https://github.com/Discngine/fpocket/archive/refs/tags/4.0.0.tar.gz"
  sha256 "97b808b233b0fc314fe5e32c9cc8cc7d4377b53aba36807a5554a180f13524c0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "80018eb3725cf7c60387fa1a26d28250511b7501321e446af21c95de8b0dca04"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2f1b7d8467acb1970ca0ac8b657b18e04a88681f23990a50b56334e35111c972"
  end

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
