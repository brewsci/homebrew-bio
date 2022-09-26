class Trf < Formula
  # cite Benson_1999: "https://doi.org/10.1093/nar/27.2.573"
  desc "Tandem repeats finder"
  homepage "https://github.com/Benson-Genomics-Lab/TRF"
  url "https://github.com/Benson-Genomics-Lab/TRF/archive/refs/tags/v4.09.1.tar.gz"
  sha256 "516015b625473350c3d1c9b83cac86baea620c8418498ab64c0a67029c3fb28a"
  license "AGPL-3.0-or-later"

  def install
    mkdir "build" do
      system "../configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    assert_match "period", shell_output("#{bin}/trf 2>&1", 1)
    (testpath/"test.fa").write <<~EOS
      >seq
      aggaaacctgccatggcctcctggtgagctgtcctcatccactgctcgctgcctctccag
      atactctgacccatggatcccctgggtgcagccaagccacaatggccatggcgccgctgt
      actcccacccgccccaccctcctgatcctgctatggacatggcctttccacatccctgtg
    EOS
    shell_output("#{bin}/trf #{testpath}/test.fa 2 7 7 80 10 50 500 2>&1", 1)
    out = testpath/"test.fa.2.7.7.80.10.50.500.1.txt.html"
    assert_predicate out, :exist?
    assert_match "Length: 180", File.read(out)
  end
end
