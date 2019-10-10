class ClusterPicker < Formula
  # cite RagonnetCronin_2013: "https://doi.org/10.1186/1471-2105-14-317"
  desc "Pick/describe HIV clusters in phylogenetic trees"
  homepage "http://hiv.bio.ed.ac.uk/software.html"
  url "https://github.com/emmahodcroft/cluster-picker-and-cluster-matcher/raw/master/release/ClusterPicker_1.2.5.jar"
  sha256 "8698b2c1d57d53843534780f860827f09b6bce9a323e2363085597c00e20cbb7"

  depends_on :java

  def install
    jar = Dir["*.jar"].first
    libexec.install jar
    bin.write_jar_script libexec/jar, "ClusterPicker"
  end

  test do
    # alignment
    fa = testpath/"test.fa"
    fa.write <<~EOS
      >seq1
      ATCT
      >seq2
      ATCG
      >seq3
      ATAT
    EOS
    # tree
    nw = testpath/"test.nw"
    nw.write <<~EOT
      (seq1:0.9,(seq2:0.7,seq3:0.8))
    EOT
    # run
    assert_match "Reading", shell_output("#{bin}/ClusterPicker #{fa} #{nw} 0.9 2>&1")
    assert_predicate testpath/"test_clusterPicks_log.txt", :exist?
  end
end
