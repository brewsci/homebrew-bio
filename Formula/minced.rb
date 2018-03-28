class Minced < Formula
  desc "Mining CRISPRs in Environmental Datasets"
  homepage "https://github.com/ctSkennerton/minced"
  url "https://github.com/ctSkennerton/minced/archive/0.2.1.tar.gz"
  sha256 "2570aa20d5fd6bdc1003ecf3cd84a403896261fa45cec131fe1a063a11f7b648"
  head "https://github.com/ctSkennerton/minced.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e4348c04b536cca44dfd5579c774bcc07f22bc04120386a41aff6bf123b5a56c" => :sierra_or_later
    sha256 "25df8ae353d74b462539fe1e8d60a16a45160f2a87a95e21a40915a81f6a9382" => :x86_64_linux
  end
 
  depends_on :java

  def install
    system "make", "JC=javac -source 1.7"
    libexec.install "minced.jar"
    bin.write_jar_script libexec/"minced.jar", "minced"
    pkgshare.install Dir["t/*"]
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
    assert_match "1\t507\t9", shell_output("#{bin}/minced -gff #{testpath}/test.fa")
  end
end
