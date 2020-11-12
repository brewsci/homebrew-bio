class SeqGen < Formula
  # cite Rambaut_1997: "https://doi.org/10.1093/bioinformatics/13.3.235"
  desc "Simulator of DNA and amino acid sequence evolution"
  homepage "http://tree.bio.ed.ac.uk/software/seqgen/"
  url "https://github.com/rambaut/Seq-Gen/archive/1.3.4.tar.gz"
  sha256 "092ec2255ce656a02b2c3012c32443c7d8e38c692f165fb155b304ca030cbb59"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "aa358ba771b0e3fff0eef22258ef350bf89fddc09dc544a227a557d417be38b8" => :sierra
    sha256 "3691d3c197f7cc5c03e22b8f800553d5692e4fe58e6bbea8c62e9a669e81c7f8" => :x86_64_linux
  end

  def install
    system "make", "-C", "source"
    bin.install "source/seq-gen"
    pkgshare.install ["examples", "documentation"]
  end

  test do
    (testpath/"tree").write "(((t1:0.2,t2:0.2):0.1,t3:0.3):0.1,t4:0.4);"
    output = shell_output("#{bin}/seq-gen -m GTR tree")
    assert_match "4 1000", output # 4 taxa, 1000 sites
    assert_match "t1", output
  end
end
