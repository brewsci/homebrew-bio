class Minimap < Formula
  desc "Find approx mapping positions between long sequences"
  homepage "https://github.com/lh3/minimap"
  url "https://github.com/lh3/minimap/archive/v0.2.tar.gz"
  sha256 "cfcf77cfe2d8d64b16ea60e0139363190eca4853da9dca9d872c38fe80bf5d68"
  head "https://github.com/lh3/minimap.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "1d8fb8866df4e6c4aec1a27cb7a43d48f0e63976e4888b29dbd62c9e56c358ab" => :sierra
    sha256 "de577da73870b816261d2bf2a1f90d4dc95c9d2be6404ab45c3c0ddbbb2f6fcc" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "minimap"
  end

  test do
    assert_match "mapping", shell_output("#{bin}/minimap 2>&1", 1)
  end
end
