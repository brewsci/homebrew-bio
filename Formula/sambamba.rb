class Sambamba < Formula
  # cite Tarasov_2015: "https://doi.org/10.1093/bioinformatics/btv098"
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba"
  url "https://github.com/lomereiter/sambamba.git",
      :tag => "v0.6.8",
      :revision => "96d1b755594f3075afac4b5f02f8d932c7c4919d"

  depends_on "ldc" => :build
  depends_on "python" => :build

  def install
    system "make", "utils/ldc_version_info_.d"
    system "make", "release"
    bin.install "bin/sambamba"
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
