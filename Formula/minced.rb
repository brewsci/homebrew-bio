class Minced < Formula
  desc "Mining CRISPRs in Environmental Datasets"
  homepage "https://github.com/ctSkennerton/minced"
  url "https://github.com/ctSkennerton/minced/archive/refs/tags/0.4.2.tar.gz"
  sha256 "35b6ee22fe6bdc26a31d0203a7dcc6bd1a19fd6733c60d80ceb44431884af165"
  license "GPL-3.0"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "846f648f698d7291bfa04f480e91e90ddb55cc3467f3be3aff43a07a6015804b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce6f5782aee93c447c47e4cfc5dc4dd1bd9ee4f602bd371b488112a026e9acf4"
    sha256 cellar: :any_skip_relocation, ventura:       "65d4f82b10786c302348d4f44717c6cc05891d31a5ca67fe731d947609ff1c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30e4290a7f59a5758b879f293ea0a8477dc0e74957c7ec5653c259c7e2e715bc"
  end

  depends_on "openjdk"

  def install
    system "make"
    jar = "minced.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "minced"
  end

  test do
    (testpath/"test.fa").write <<~EOS
      >CRISPR Escherichia coli UTI89 886538..887045
      GTTCACTGCCGTACAGGCAGCTTAGAAATGACGCCATATGCAGATCATTGAGGCGAAACC
      GTTCACTGCCGTACAGGCAGCTTAGAAAACGTTCGCACCGGTCAGGGTACTGCGCAGCGT
      GTTCACTGCCGTACAGGCAGCTTAGAAAGAAACCAGAGCGCCCGCATAAAACAGGCACAA
      GTTCACTGCCGTACAGGCAGCTTAGAAAGCCAGCATAAAACCGCCTTTGATATTTTATTG
      GTTCACTGCCGTACAGGCAGCTTAGAAATCAGCCGGAGGCTCTCAATTTCAGCCGCGCGG
      GTTCACTGCCGTACAGGCAGCTTAGAAAAGCACGGCTGCGGGGAATGGCTCAATCTCTGC
      GTTCACTGCCGTACAGGCAGCTTAGAAATGATGGCGCAGCAGTCCTCCCTCCTGCCGCCA
      GTTCACTGCCGTACAGGCAGCTTAGAAACTGAACGTTGAAGAGTGCGACCGTCTCTCCTT
      GTTCACTGCCGTACAGGCAGTATTCACA
    EOS
    assert_match "1\t508\t8", shell_output("#{bin}/minced -gff #{testpath}/test.fa")
  end
end
