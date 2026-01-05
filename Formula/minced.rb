class Minced < Formula
  desc "Mining CRISPRs in Environmental Datasets"
  homepage "https://github.com/ctSkennerton/minced"
  url "https://github.com/ctSkennerton/minced/archive/refs/tags/0.4.2.tar.gz"
  sha256 "35b6ee22fe6bdc26a31d0203a7dcc6bd1a19fd6733c60d80ceb44431884af165"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "100aa02c3791505242f4b493b4bda072ba20a1ae6dfba3acce531441c570b2c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a94873a2763908b1003c82ef6d06a7522e83cde276676fefd7bdf7206d288e49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf4a684b40fa3c1367e813f5d877f04c63fc85d74a6dc99e2edc58e6c4da553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f658feea8003af87fe6eb0079fe40b7c04f3277f3949d4453cf2b06d9c9ce05"
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
