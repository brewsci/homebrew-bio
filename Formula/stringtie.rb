class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://ccb.jhu.edu/software/stringtie"
  url "https://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.4c.tar.gz"
  sha256 "5f3595a241349fdb4ff12391ae39d3d86ede31a32244ce9410af36dc42bd5b92"
  head "https://github.com/gpertea/stringtie.git"

  # cite "https://doi.org/10.1038/nbt.3122"

  def install
    system "make", "release"
    bin.install "stringtie"
  end

  test do
    assert_match "transcripts", shell_output("#{bin}/stringtie 2>&1", 1)
  end
end
