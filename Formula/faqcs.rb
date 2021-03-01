class Faqcs < Formula
  # cite Lo_2014: "https://doi.org/10.1186/s12859-014-0366-2"
  desc "Quality Control of Next Generation Sequencing Data"
  homepage "https://github.com/LANL-Bioinformatics/FaQCs"
  url "https://github.com/LANL-Bioinformatics/FaQCs/archive/2.10.tar.gz"
  sha256 "0458e3500adab5257ba11d1db5402adfc52feb936da39c0a26089cbfc1007832"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "258fb769595a3a22700bb2f102092803a419cd723f6ee43874807af3c3a7a42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "34097faab16f1a1d2fe1f227a39facd5e32e4addf3984624dd50fa95069b30dd"
  end

  depends_on "jellyfish"
  depends_on "r"
  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "FaQCs"
    bin.install "VTrim"
  end

  test do
    (testpath/"test.fq").write <<~EOS
      @SRR3537005.1.1 HS3:448:C3EJWACXX:3:1101:1180:2131 length=100
      TTTTGTTGTTAGGGTTAGTTTTAAAGAGGTAGGGAGGAAGTTGAGGGGTAGTTGTTAATTGTTGTTTTTTTTTAAAGATTAGTTGTTTTTATTTGAAAAT
      +
      CCCFFFFFHHHHHIHFHJIJJJIJJHIIJEGHIIEHIIIIBBGHIIHJ<FHIIJIIJJJJJJHHHGHFFDDDDDDDDDDDDDDDDDDDDDDDDEEEDDDD
      @SRR3537005.2.1 HS3:448:C3EJWACXX:3:1101:1169:2184 length=100
      AAAGTTATTTGGTAATTTTTAGTTTAAAGAGATAGTAGGTGTTATTGTGTTTGAGGTTTATTTA
      +
      @B@FDDFFGHFHFFFIHJJJJFHHGIJJCH;EHIICFIJGHIHJJJJGEHIIGHECFFHIJJII
      @SRR3537005.3.1 HS3:448:C3EJWACXX:3:1101:1473:2047 length=100
      TGGTGGCGTGTATATGTAAAGTATATTAGATTCGTGCGTGAAGTAGGTATATATTATTAAGTTGTGGTTGGAATTGATTAGGAAGTATTTGGTAGAAGG
      +
      @CCFFFDDHHHHGIJJFGIJHFFGIIJJHIGGIJEFDD?FHIJHGFH?DHHIJJIJJJIIC@FHHIIEGHHHHFFEFFFEDEEEEACFEEFDDDDDDDD
      @SRR3537005.4.1 HS3:448:C3EJWACXX:3:1101:1428:2062 length=100
      GTAATTTTAGGTTGTTTATAAGGATGGATTAGGCGGGTTACGAAAGAGGGGGTTTTGTAGGGTATGGGGTTTTGTAGGTAGGAGTTGTGTTTAATATTGG
      +
      @BCFFFFFHHHCFBHHIJJJICFGIIGIHHG3CEGEBA;@AEGHE:BEB<A@=B@@AAD>:?3>>:ABD5;BDBDACDACDBAC39C>@ACCDDCEEEDD
    EOS
    system "#{bin}/FaQCs", "-u", "#{testpath}/test.fq", "-d", testpath, "-qc_only"
    assert_predicate testpath/"QC.stats.txt", :exist?
    assert_predicate testpath/"QC_qc_report.pdf", :exist?
  end
end
