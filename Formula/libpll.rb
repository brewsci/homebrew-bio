class Libpll < Formula
  # cite Flouri_2015: "https://doi.org/10.1093/sysbio/syu084"
  desc "Phylogenetic likelihood library"
  homepage "http://www.libpll.org/"
  url "http://www.libpll.org/Downloads/libpll-1.0.11.tar.gz"
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
    system "make", "install"
  end

  test do
    (testpath/"test.phy").write <<~EOS
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
    EOS

    (testpath/"test.tree").write "(Whale,(((Mouse,Rat),(Human,(Chicken,(Frog,(Loach,Carp))))),Seal),Cow);"

    (testpath/"test.part").write "DNA, p1=1-60"

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <assert.h>
      #include <pll/pll.h>

      int main (int argc, char * argv[]) {
        pllAlignmentData * alignmentData;
        pllInstance * tree;
        pllNewickTree * newick;
        partitionList * partitions;
        pllQueue * partitionInfo;
        pllInstanceAttr attr;
        pllRearrangeList * rearrangeList;

        attr.rateHetModel     = PLL_GAMMA;
        attr.fastScaling      = PLL_FALSE;
        attr.saveMemory       = PLL_FALSE;
        attr.useRecom         = PLL_FALSE;
        attr.randomNumberSeed = 0xDEADBEEF;
        attr.numberOfThreads  = 1;

        tree = pllCreateInstance (&attr);
        alignmentData = pllParseAlignmentFile (PLL_FORMAT_PHYLIP, argv[1]);
        newick = pllNewickParseFile (argv[2]);
        partitionInfo = pllPartitionParse (argv[3]);
        partitions = pllPartitionsCommit (partitionInfo, alignmentData);
        partitions->perGeneBranchLengths = PLL_TRUE;
        pllQueuePartitionsDestroy (&partitionInfo);
        pllAlignmentRemoveDups (alignmentData, partitions);
        pllTreeInitTopologyNewick (tree, newick, PLL_TRUE);
        pllLoadAlignment (tree, alignmentData, partitions);
        pllInitModel (tree, partitions);
        pllOptimizeBranchLengths (tree, partitions, 64);

        printf ("%f\\n",tree->likelihood);

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lpll-sse3"

    assert_match "-403.432853", shell_output("./test test.phy test.tree test.part")
  end
end
