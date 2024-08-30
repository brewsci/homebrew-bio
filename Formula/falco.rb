class Falco < Formula
  # cite deSena_2021: "https://doi.org/10.12688/f1000research.21142.2"
  desc "C++ implementation of FastQC for quality control of sequencing data"
  homepage "https://github.com/smithlabcode/falco"
  url "https://github.com/smithlabcode/falco/releases/download/v1.2.3/falco-1.2.3.tar.gz"
  sha256 "b2d4da736efecfa669ad555fbb69862bc7fb57dcf32efcb6c151c47f98b32b8a"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, monterey:     "6eef92c3969b186ebc3133a8762fa9ba534c0618dd8c947ab7cb07524133551e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1f1bce178223383d01286a20f134667b29f6fd413b7d21f316c7d53705a3acb6"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "all"
    system "make", "install"
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
    system "#{bin}/falco", "#{testpath}/test.fq"
    assert_predicate testpath/"summary.txt", :exist?
    assert_predicate testpath/"fastqc_report.html", :exist?
  end
end
