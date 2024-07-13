class Prank < Formula
  desc "Multiple alignment for DNA, codon and amino-acid sequences"
  homepage "https://ariloytynoja.github.io/prank-msa/"
  url "http://wasabiapp.org/download/prank/prank.source.170427.tgz"
  sha256 "623eb5e9b5cb0be1f49c3bf715e5fabceb1059b21168437264bdcd5c587a8859"
  head "https://github.com/ariloytynoja/prank-msa.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "4a2850440399401f741ab36b3dc259bf58ab9172b0ad748f6b7d3036e2382384"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f5636af90d0bb5adcc132bd20c4f08763453411068768af1f2275ff0e6455abb"
  end

  depends_on "brewsci/bio/exonerate"
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
