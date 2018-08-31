class Sambamba < Formula
  # cite Tarasov_2015: "https://doi.org/10.1093/bioinformatics/btv098"
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba"
  url "https://github.com/lomereiter/sambamba.git",
      :tag => "v0.6.7",
      :revision => "18b1df553e58b4cd6a8ddb64e59bbd9a167d44f1"

  depends_on "ldc" => :build
  depends_on "python@2" => :build unless OS.mac?

  resource "undeaD" do
    url "https://github.com/dlang/undeaD/archive/v1.0.9.tar.gz"
    sha256 "d32eebcce826f2bc1af71a3ea37f0677485c6e04fb5d4cb0565ed66777569125"
  end

  def install
    (buildpath/"undeaD").install resource("undeaD")
    system "make", "sambamba-ldmd2-64"
    bin.install "build/sambamba"
    pkgshare.install "BioD/test/data/ex1_header.bam"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/sambamba --help 2>&1")
    system "#{bin}/sambamba",
      "sort", "-t2", "-n", "#{pkgshare}/ex1_header.bam",
      "-o", "ex1_header.nsorted.bam", "-m", "200K"
    assert_predicate testpath/"ex1_header.nsorted.bam", :exist?
  end
end
