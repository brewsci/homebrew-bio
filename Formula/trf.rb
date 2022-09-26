class Trf < Formula
  # cite Benson_1999: "https://doi.org/10.1093/nar/27.2.573"
  desc "Tandem repeats finder"
  homepage "https://github.com/Benson-Genomics-Lab/TRF"
  url "https://github.com/Benson-Genomics-Lab/TRF/archive/refs/tags/v4.09.1.tar.gz"
  sha256 "516015b625473350c3d1c9b83cac86baea620c8418498ab64c0a67029c3fb28a"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, big_sur:      "de05c4192f049253aa589c89ded482390b6dcd151b6ccf3e26041079bd9f6c88"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "75eb2ebae1c474538e8103cd0facaccc15cd080456df480a8c03ad08d1fec758"
  end

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
