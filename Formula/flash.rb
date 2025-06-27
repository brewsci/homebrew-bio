class Flash < Formula
  # cite Magoc_2011: "https://doi.org/10.1093/bioinformatics/btr507"
  desc "Merge mates from overlapping fragments"
  homepage "https://ccb.jhu.edu/software/FLASH/"
  url "https://downloads.sourceforge.net/project/flashpage/FLASH-1.2.11.tar.gz"
  sha256 "685ca6f7fedda07434d8ee03c536f4763385671c4509c5bb48beb3055fd236ac"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "de91f8ecf68dd85c6935367def8e7452cbeb3039e50e4fc10393f27dbbcebcc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6ee7d8e115ea5c7ee2a4584a699f6366b8b91d8ff52dd3019f9932f56e437a18"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "flash"
  end

  test do
    assert_match "MATES", shell_output("#{bin}/flash 2>&1", 2)
    assert_match "threads", shell_output("#{bin}/flash --help 2>&1")
  end
end
