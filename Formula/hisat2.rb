class Hisat2 < Formula
  # cite Kim_2015: "https://doi.org/10.1038/nmeth.3317"
  desc "Graph-based alignment to a population of genomes"
  homepage "https://ccb.jhu.edu/software/hisat2/"
  url "https://github.com/infphilo/hisat2/archive/0f01dc6397a.tar.gz"
  version "2.1.0"
  sha256 "1e878745c8b5bf93d88986add1dcd450611ab3406a8e046e941fcf67349df664"

  fails_with :clang

  def install
    system "make"
    bin.install "hisat2", Dir["hisat2-*"]
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/hisat2 --help 2>&1")
  end
end
