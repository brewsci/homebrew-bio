class Minced < Formula
  desc "Mining CRISPRs in Environmental Datasets"
  homepage "https://github.com/ctSkennerton/minced"
  url "https://github.com/ctSkennerton/minced/releases/download/0.4.0/minced.jar"
  sha256 "b643d7e56335c0ce9fb95aee7958accb7ebc50ce385f4e12a5abc5547bf7fad6"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "ad305c528a5993583fea3daf9211cad4d4080dcfc8cc3d2c7c9b3562c1d197c2" => :sierra
    sha256 "05c96b71921f6afaf5f0552dcc6be206c441b9e46d04fa5f0ad56be82bd9336a" => :x86_64_linux
  end

  depends_on :java

  def install
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
