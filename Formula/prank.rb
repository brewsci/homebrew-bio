class Prank < Formula
  desc "Multiple alignment for DNA, codon and amino-acid sequences"
  homepage "https://ariloytynoja.github.io/prank-msa/"
  url "http://wasabiapp.org/download/prank/prank.source.170427.tgz"
  sha256 "623eb5e9b5cb0be1f49c3bf715e5fabceb1059b21168437264bdcd5c587a8859"
  revision 1
  head "https://github.com/ariloytynoja/prank-msa.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "ecf7c563b9f65a477472da84b4466984758240aabf5698071fa8f6b85cf44e23"
    sha256 cellar: :any_skip_relocation, ventura:      "4410e054413713681810b06e68d2dd9fac05a8b0b715869262c4d08cca38d9b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bfa66458bfb90ac261177a5c3007daac9f53701f86c48df4876e4c2400d110a6"
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
