class Prank < Formula
  desc "Multiple alignment for DNA, codon and amino-acid sequences"
  homepage "https://ariloytynoja.github.io/prank-msa/"
  url "http://wasabiapp.org/download/prank/prank.source.170427.tgz"
  sha256 "623eb5e9b5cb0be1f49c3bf715e5fabceb1059b21168437264bdcd5c587a8859"
  revision 1
  head "https://github.com/ariloytynoja/prank-msa.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e9dd55908217cf7c5d264f0e4f8b3a3c7a6dec25b5b845e5f776434e4be9ff3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41b3b4f6a940f8e1f66131e618661dfb46ed9220ec0389f6d56c1fc1a2163383"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26121d8553e01fe2f83938ca16d099ee36888e91ed58c294ce326df266ca1239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b050fe8cd099253548161a7fc0307a84ac379f6b1fcbb64c9d042e306ad7b7eb"
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
