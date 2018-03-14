class Minimap < Formula
  desc "Find approx mapping positions between long sequences"
  homepage "https://github.com/lh3/minimap"
  url "https://github.com/lh3/minimap/archive/v0.2.tar.gz"
  sha256 "cfcf77cfe2d8d64b16ea60e0139363190eca4853da9dca9d872c38fe80bf5d68"
  head "https://github.com/lh3/minimap.git"

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "minimap"
  end

  test do
    assert_match "mapping", shell_output("#{bin}/minimap 2>&1", 1)
  end
end
