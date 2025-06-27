class Minimap < Formula
  desc "Find approx mapping positions between long sequences"
  homepage "https://github.com/lh3/minimap"
  url "https://github.com/lh3/minimap/archive/v0.2.tar.gz"
  sha256 "cfcf77cfe2d8d64b16ea60e0139363190eca4853da9dca9d872c38fe80bf5d68"
  license "MIT"
  head "https://github.com/lh3/minimap.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "1d8fb8866df4e6c4aec1a27cb7a43d48f0e63976e4888b29dbd62c9e56c358ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "de577da73870b816261d2bf2a1f90d4dc95c9d2be6404ab45c3c0ddbbb2f6fcc"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "minimap"
  end

  test do
    assert_match "mapping", shell_output("#{bin}/minimap 2>&1", 1)
  end
end
