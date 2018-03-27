class Minced < Formula
  desc "Mining CRISPRs in Environmental Datasets"
  homepage "https://github.com/ctSkennerton/minced"
  url "https://github.com/ctSkennerton/minced/archive/0.2.1.tar.gz"
  sha256 "2570aa20d5fd6bdc1003ecf3cd84a403896261fa45cec131fe1a063a11f7b648"
  head "https://github.com/ctSkennerton/minced.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1c15ae6c44f97b2942a613c38ea05052fa324d17823d096b5cb33728f1cdbaf" => :sierra
    sha256 "357e033708312a17f0625b4cc51092ce51070c8c69b2cff72f2ba82d80e1bc50" => :x86_64_linux
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
