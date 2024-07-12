class Aragorn < Formula
  # cite Laslett_2004: "https://doi.org/10.1093/nar/gkh152"
  desc "Detect tRNA and tmRNA genes in contigs"
  homepage "https://www.trna.se/ARAGORN/"
  url "https://www.trna.se/ARAGORN/Downloads/aragorn1.2.41.c"
  sha256 "92a31cc5c0b0ad16d4d7b01991989b775f07d2815df135fe6e3eab88f5e97f4a"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "f896ddcae611fbc70e626039eefb08613ccc734ad5bd2c17cd8f514f1531021a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7670f2b0c66f5567844300f3c7b909cc679948e2fea74657631b025b24ce0520"
  end

  def install
    mv "aragorn#{version}.c", "aragorn.c"
    system "make", "aragorn"
    bin.install "aragorn"
  end

  test do
    (testpath/"test.fa").write <<~EOS
      >sequence
      GGGGCTATAGCTCAGTTGGGAGAGCGCTGCAATCGCACTG
      CAGAGGTCGTCAGTTCGAACCTGACTAGCTCCACCA
    EOS
    assert_match "tRNA-Ala", shell_output("#{bin}/aragorn -w #{testpath}/test.fa")
  end
end
