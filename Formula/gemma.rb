class Gemma < Formula
  desc "Linear mixed models (LMMs) and related models to genome-wide association studies (GWAS)"
  homepage "https://lomereiter.github.io/gemma"
  url "https://github.com/genetics-statistics/gemma.git" # , :revision => "595197546e1418b4944e2f797d8ceac6d495f741"
  version "0.98"

  # depends_on "ldc" => :build
  # depends_on "python" => :build
  depends_on "openblas"
  depends_on "gsl"
  depends_on "eigen"
  depends_on "zlib"

  def install
    system "make"
    system "make", "check"
    bin.install "bin/gemma"
    # pkgshare.install "BioD/test/data/ex1_header.bam"
  end

  test do
    # assert_match "Usage", shell_output("#{bin}/gemma --help 2>&1", 1)
    # system "#{bin}/gemma",
    #   "sort", "-t2", "-n", "#{pkgshare}/ex1_header.bam",
    #   "-o", "ex1_header.nsorted.bam", "-m", "200K"
    assert_predicate testpath/"ex1_header.nsorted.bam", :exist?
  end
end
