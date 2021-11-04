class Tmalign < Formula
  # cite Zhang_2005: "https://doi.org/10.1093/nar/gki524"
  desc "Protein structure alignment algorithm based on the TM-score"
  homepage "https://github.com/kad-ecoli/TMalign"
  url "https://github.com/kad-ecoli/TMalign/archive/f0824499d8ab4fa84b2e75d253de80ab2c894c56.tar.gz"
  version "20210527"
  sha256 "facb87dae6f1918c78859990113877f7d08b8395d04d18c04ab4b5fc9b08610d"
  license "MIT"

  def install
    # install cpp version
    system ENV.cxx, "-O3", "-ffast-math", "-lm", "-o", "TMalign", "TMalign.cpp"
    bin.install "TMalign"
  end

  test do
    assert_match "usage", shell_output("#{bin}/TMalign -h 2>&1")
  end
end
