class Hisat2 < Formula
  # cite Kim_2015: "https://doi.org/10.1038/nmeth.3317"
  desc "Graph-based alignment to a population of genomes"
  homepage "https://ccb.jhu.edu/software/hisat2/"
  url "https://github.com/infphilo/hisat2/archive/0f01dc6397a.tar.gz"
  version "2.1.0"
  sha256 "1e878745c8b5bf93d88986add1dcd450611ab3406a8e046e941fcf67349df664"
  head "https://github.com/infphilo/hisat2.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "8cd78c6f9d9ac19a25c1768d7825686272a0edd05cdad3f93fa152d31470c8cf" => :sierra
    sha256 "63de0abb3432c7f2f5b1141c002885016c960d1575d7bb7e13d59f0e28e5075d" => :x86_64_linux
  end

  fails_with :clang

  def install
    system "make"
    bin.install "hisat2", Dir["hisat2-*"]
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/hisat2 --help 2>&1")
  end
end
