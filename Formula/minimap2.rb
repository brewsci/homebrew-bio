class Minimap2 < Formula
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.3/minimap2-2.3.tar.bz2"
  sha256 "a7bad55254bc4011d4501c2a5a21fd30443ffd04cbcbe28ba190ae160f7955e6"
  head "https://github.com/lh3/minimap2.git"
  # doi "https://arxiv.org/abs/1708.01492"

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "minimap2"
    man1.install "minimap2.1"
    pkgshare.install "python", "test"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/minimap2 --help 2>&1")
  end
end
