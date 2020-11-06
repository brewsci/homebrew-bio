class Gffcompare < Formula
  desc "Classify, merge, tracking and annotation of GFF files"
  homepage "https://github.com/gpertea/gffcompare"
  url "https://github.com/gpertea/gffcompare/releases/download/v0.12.1/gffcompare-0.12.1.tar.gz"
  sha256 "3d9b26ba0080fd619a45be8d2a8f853b84408d02f46ee66c103bf024f27f013c"
  license "MIT"
  head "https://github.com/gpertea/gffcompare.git"

  def install
    ENV.deparallelize
    system "make", "release"
    bin.install "gffcompare", "trmap"
    doc.install "LICENSE", "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/gffcompare --help 2>&1")
    assert_match "Usage", shell_output("#{bin}/trmap --help 2>&1")
  end
end
