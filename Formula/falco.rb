class Falco < Formula
  # cite deSena_2021: "https://doi.org/10.12688/f1000research.21142.2"
  desc "C++ implementation of FastQC for quality control of sequencing data"
  homepage "https://github.com/smithlabcode/falco"
  url "https://github.com/smithlabcode/falco/releases/download/v1.2.3/falco-1.2.3.tar.gz"
  sha256 "b2d4da736efecfa669ad555fbb69862bc7fb57dcf32efcb6c151c47f98b32b8a"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adff2b98e797cf89218037f932b325efe70b3c7aad424f0dbfa9af8ff456d858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a489e4df839aca797e0a6102588e096139ff7275cf4aeeee2553d6aa384c8178"
    sha256 cellar: :any_skip_relocation, ventura:       "9b1758aa47f6e3317176ce2839c2ff1e1327de7d0e83cf22c9e99a3eba9fa4fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86b5237f075fcdfa134c0c8e0d51621e67ecec0484044dbfb8534197c82b8ac1"
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
    assert_path_exists testpath/"summary.txt"
    assert_path_exists testpath/"fastqc_report.html"
  end
end
