class Sambamba < Formula
  # cite Tarasov_2015: "https://doi.org/10.1093/bioinformatics/btv098"
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba"
  url "https://github.com/lomereiter/sambamba.git",
      :tag => "v0.6.6",
      :revision => "63cfd5c7b3053e1f7045dec0b5a569f32ef73d06"

  resource "undeaD" do
    url "https://github.com/dlang/undeaD/archive/v1.0.6.tar.gz"
    sha256 "fbdfe2be480e71988599b0d980545892929a899aa76f09de6c4ed8f5558c70c0"
  end

  depends_on "ldc" => :build
  depends_on "python@2" => :build unless OS.mac?

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
