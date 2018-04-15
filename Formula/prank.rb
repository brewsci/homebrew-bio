class Prank < Formula
  desc "Multiple alignment for DNA, codon and amino-acid sequences"
  homepage "http://wasabiapp.org/software/prank/"
  url "http://wasabiapp.org/download/prank/prank.source.170427.tgz"
  sha256 "623eb5e9b5cb0be1f49c3bf715e5fabceb1059b21168437264bdcd5c587a8859"
  head "https://github.com/ariloytynoja/prank-msa.git"

  depends_on "exonerate"
  depends_on "mafft"

  def install
    cd "src" do
      system "make"
      bin.install "prank"
      man1.install "prank.1"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prank -help 2>&1")
  end
end
