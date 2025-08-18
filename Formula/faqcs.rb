class Faqcs < Formula
  # cite Lo_2014: "https://doi.org/10.1186/s12859-014-0366-2"
  desc "Quality Control of Next Generation Sequencing Data"
  homepage "https://github.com/LANL-Bioinformatics/FaQCs"
  url "https://github.com/LANL-Bioinformatics/FaQCs/archive/refs/tags/2.12.tar.gz"
  sha256 "cff6ada0f9ecc5a72fb5c484addd304f35952b1b11424c74016b827d21a07384"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11064ff6d15390db5f426cb90dbe5b7cec26731bc00eb71987cde9c6893c44ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30383f8608037b1dfc76e58f7c246579c5a7e98b8b65cee414da999287f393e0"
    sha256 cellar: :any_skip_relocation, ventura:       "f33a533cdd209e1652c4900ca1a0fbfb2e2985fb5e6b008c4b1cd0d69ea11957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bbaf8e07a6a37514afb261141754d093dd2354a752e28b68a679cb19a6fb252"
  end

  depends_on "jellyfish"
  depends_on "r"
  uses_from_macos "zlib"
  on_macos do
    depends_on "libomp"
  end

  resource "sse2neon" do
    url "https://raw.githubusercontent.com/DLTcollab/sse2neon/v1.8.0/sse2neon.h"
    sha256 "07723c9f9457dd4316f1fde3dd4eb6f31dd67d9955f6c21f4e609ac1698be48a"
  end

  def install
    inreplace "Makefile" do |s|
      s.gsub! "gcc", "$(CC)"
      s.gsub! "g++", "$(CXX)"
      s.gsub! "-I.", "-I. -I$(PREFIX)/include"
    end
    # use sse2neon for ARM
    if OS.mac? && Hardware::CPU.arm?
      buildpath.install resource("sse2neon")
      inreplace "seq_overlap.h", "#include <xmmintrin.h>", "#include \"sse2neon.h\""
      inreplace "Makefile", "-msse2", ""
    end
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
    assert_path_exists testpath/"QC.stats.txt"
    assert_path_exists testpath/"QC_qc_report.pdf"
  end
end
