class Flash < Formula
  # cite Magoc_2011: "https://doi.org/10.1093/bioinformatics/btr507"
  desc "Merge mates from overlapping fragments"
  homepage "https://ccb.jhu.edu/software/FLASH/"
  url "https://downloads.sourceforge.net/project/flashpage/FLASH-1.2.11.tar.gz"
  sha256 "685ca6f7fedda07434d8ee03c536f4763385671c4509c5bb48beb3055fd236ac"

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "flash"
  end

  test do
    assert_match "MATES", shell_output("#{bin}/flash 2>&1", 2)
    assert_match "threads", shell_output("#{bin}/flash --help 2>&1", 0)
  end
end
