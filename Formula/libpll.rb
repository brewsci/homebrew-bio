class Libpll < Formula
  # cite Flouri_2015: "https://doi.org/10.1093/sysbio/syu084"
  desc "Phylogenetic likelihood library"
  homepage "http://www.libpll.org/"
  url "http://www.libpll.org/Downloads/libpll-1.0.11.tar.gz"
  sha256 "45107d59d87be921c522478bb3688beee60dc79154e0b4a183af01122c597132"
  sha256 "1fb7af4d09bb935b0cc6c4d0ddff21a29ceff38c401328543d1639299ea31ec1"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "6c0db69ccdf356afb339511e1acd31664f2c5742aba5ce0045c7ff6eecdeed6a" => :sierra_or_later
    sha256 "58b69c916fcea6f08e91ce956b5f426416506cf70a0ca13763bf3578b0a014fb" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    cp_r buildpath/"examples", testpath

    cd testpath/"examples"/"PLL" do
      system "make", "-f", "Makefile.SSE3"

      (testpath/"test.tree").write "(Whale,(((Mouse,Rat),(Human,(Chicken,(Frog,(Loach,Carp))))),Seal),Cow);"
      (testpath/"test.part").write "DNA, p1=1-60"
      (testpath/"test.phy").write <<~EOF
        10 60
        Cow       ATGGCATATCCCATACAACTAGGATTCCAAGATGCAACATCACCAATCATAGAAGAACTA
        Carp      ATGGCACACCCAACGCAACTAGGTTTCAAGGACGCGGCCATACCCGTTATAGAGGAACTT
        Chicken   ATGGCCAACCACTCCCAACTAGGCTTTCAAGACGCCTCATCCCCCATCATAGAAGAGCTC
        Human     ATGGCACATGCAGCGCAAGTAGGTCTACAAGACGCTACTTCCCCTATCATAGAAGAGCTT
        Loach     ATGGCACATCCCACACAATTAGGATTCCAAGACGCGGCCTCACCCGTAATAGAAGAACTT
        Mouse     ATGGCCTACCCATTCCAACTTGGTCTACAAGACGCCACATCCCCTATTATAGAAGAGCTA
        Rat       ATGGCTTACCCATTTCAACTTGGCTTACAAGACGCTACATCACCTATCATAGAAGAACTT
        Seal      ATGGCATACCCCCTACAAATAGGCCTACAAGATGCAACCTCTCCCATTATAGAGGAGTTA
        Whale     ATGGCATATCCATTCCAACTAGGTTTCCAAGATGCAGCATCACCCATCATAGAAGAGCTC
        Frog      ATGGCACACCCATCACAATTAGGTTTTCAAGACGCAGCCTCTCCAATTATAGAAGAATTA
      EOF

      system "./pll-sse3", "test.phy", "test.tree", "test.part", 1
    end
  end
end
