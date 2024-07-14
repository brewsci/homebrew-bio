class Aragorn < Formula
  # cite Laslett_2004: "https://doi.org/10.1093/nar/gkh152"
  desc "Detect tRNA and tmRNA genes in contigs"
  homepage "https://www.trna.se/ARAGORN/"
  url "https://www.trna.se/ARAGORN/Downloads/aragorn1.2.41.c"
  sha256 "92a31cc5c0b0ad16d4d7b01991989b775f07d2815df135fe6e3eab88f5e97f4a"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "6ad40e4ae9cef07f117447d365c4f9ebf504552b9dbe3ecbab776ca5bbd4fd91"
    sha256 cellar: :any_skip_relocation, ventura:      "30a3be4416f0b39accc6df7bc13fca54a57447c9d4c24d3d21522fb828475858"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c599f7030cb9d41f2737e8dcefabd966e158113ee8808af82cbd99e83e42115b"
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
