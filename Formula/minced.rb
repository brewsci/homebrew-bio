class Minced < Formula
  desc "Mining CRISPRs in Environmental Datasets"
  homepage "https://github.com/ctSkennerton/minced"
  url "https://github.com/ctSkennerton/minced/releases/download/0.4.0/minced.jar"
  sha256 "b643d7e56335c0ce9fb95aee7958accb7ebc50ce385f4e12a5abc5547bf7fad6"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0a48b74df3e25ebec567c1935f324a647f1bf392e0b6e7d2640202456e7edff1" => :sierra
    sha256 "c4f31d9bd1ebc1303502e1290051d1a446fd8440a3bdaadedab8476614517598" => :x86_64_linux
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
