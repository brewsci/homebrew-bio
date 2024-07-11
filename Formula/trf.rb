class Trf < Formula
  # cite Benson_1999: "https://doi.org/10.1093/nar/27.2.573"
  desc "Tandem repeats finder"
  homepage "https://github.com/Benson-Genomics-Lab/TRF"
  url "https://github.com/Benson-Genomics-Lab/TRF/archive/refs/tags/v4.09.1.tar.gz"
  sha256 "516015b625473350c3d1c9b83cac86baea620c8418498ab64c0a67029c3fb28a"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "2d3dfef83f9cf594adb29e844670e2b4d65c3ff653fe0b9d16a66dc84c1e1307"
    sha256 cellar: :any_skip_relocation, ventura:      "cbdfefdd27900ac8e0395217972cbcfe08ac8e4c4b629b57669672dc0eddfeef"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "86759341581e33a708de7861b66f0d6e7b01ca7fd5f84224339c54444803aef9"
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
