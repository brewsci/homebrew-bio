class Trimadap < Formula
  desc "Fast but inaccurate adapter trimmer for Illumina reads"
  homepage "https://github.com/lh3/trimadap"
  url "https://github.com/lh3/trimadap/archive/0.1.tar.gz"
  sha256 "553069d81004b120d9df7d6161edce9317c0f95e5eefe2ec3325dd4081a90acd"

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "trimadap-mt"
    doc.install "illumina.txt", "test.fa"
    bin.install_symlink "trimadap-mt" => "trimadap"
  end

  test do
    assert_match /^1 +ATCTCGTATGCCGTCTTCTGCTTG$/, shell_output("#{bin}/trimadap #{doc}/test.fa 2>&1")
  end
end
