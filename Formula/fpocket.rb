class Fpocket < Formula
  desc "Protein pocket detection algorithm based on Voronoi tessellation"
  homepage "https://github.com/Discngine/fpocket"
  url "https://github.com/Discngine/fpocket/archive/refs/heads/master.tar.gz"
  version "4.0"
  sha256 "8995617b3510ee7a0eeb0d15860932fdbcb2318872d8e803a0265a71aac58952"
  license "MIT"

  depends_on "netcdf"

  def install
    system "make" if OS.linux?
    system "make", "ARCH=MACOSXX86_64" if OS.mac?
    bin.install Dir["bin/*pocket"]
  end

  test do
    assert_match "***** POCKET HUNTING BEGINS *****", shell_output("#{bin}/fpocket")
  end
end
