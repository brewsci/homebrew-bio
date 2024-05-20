class Ibdseq < Formula
  # cite Browning_2013: "https://doi.org/10.1016/j.ajhg.2013.09.014"
  desc "Detect identity-by-descent segments in unphased genotype data"
  homepage "https://faculty.washington.edu/browning/ibdseq.html"
  url "https://faculty.washington.edu/browning/ibdseq/ibdseq.r1206.zip"
  sha256 "a835c7282444d8920109362ca012f9a9ac1eb54665d34fb0ca0380a3e0fed8ec"
  license "Apache-2.0"

  depends_on "openjdk"

  def install
    chdir ".." do
      system "#{Formula["openjdk"].bin}/javac", "-cp", "src/", "src/ibdseq/IbdSeqMain.java"
      system "#{Formula["openjdk"].bin}/jar", "-cfe", "ibdseq.jar", "ibdseq.IbdSeqMain", "-C", "src/", "."

      libexec.install "ibdseq.jar"
      bin.write_jar_script libexec/"ibdseq.jar", "ibdseq"
    end
  end

  test do
    assert_predicate bin/"ibdseq", :executable?
    assert_predicate libexec/"ibdseq.jar", :exist?
    assert_match "usage: java -jar ibdseq.jar", shell_output("#{bin}/ibdseq")
  end
end
