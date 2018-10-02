class Bfc < Formula
  # Li_2015: "https://doi.org/10.1093/bioinformatics/btv290"
  desc "High-performance error correction for Illumina resequencing data"
  homepage "https://github.com/lh3/bfc"
  url "https://github.com/lh3/bfc/archive/submitted-v1.tar.gz"
  version "r175"
  sha256 "0fad5807a417f8cc033b5deea04c0fa763947e55415372f89bd2914df48154b7"

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "bfc", "hash2cnt"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bfc -v 2>&1")
  end
end
