class Minced < Formula
  desc "Mining CRISPRs in Environmental Datasets"
  homepage "https://github.com/ctSkennerton/minced"
  url "https://github.com/ctSkennerton/minced/archive/refs/tags/0.4.2.tar.gz"
  sha256 "35b6ee22fe6bdc26a31d0203a7dcc6bd1a19fd6733c60d80ceb44431884af165"
  license "GPL-3.0-or-later"
  revision 1

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
