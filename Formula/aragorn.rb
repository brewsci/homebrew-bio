class Aragorn < Formula
  # cite Laslett_2004: "https://doi.org/10.1093/nar/gkh152"
  desc "Detect tRNA and tmRNA genes in contigs"
  homepage "https://www.trna.se/ARAGORN/"
  url "https://www.trna.se/ARAGORN/Downloads/aragorn1.2.41.c"
  sha256 "92a31cc5c0b0ad16d4d7b01991989b775f07d2815df135fe6e3eab88f5e97f4a"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "981b5d66a239d7886bcbf1158a9379a04f20459061b662afcd14fef8efc4cf30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76a0b73235373b1dd5613f9d43ee5b9330a7822680c7dea0cda014800ad896ee"
    sha256 cellar: :any_skip_relocation, ventura:       "cbefb172f41cc5cb20f07c451520d0e69fc79cfb77d367b01c5fbe1dde1db741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61be229edded53f01ee879159f950df47875844f0bc1af711008677b46f4f24e"
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
