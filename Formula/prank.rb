class Prank < Formula
  desc "Multiple alignment for DNA, codon and amino-acid sequences"
  homepage "https://ariloytynoja.github.io/prank-msa/"
  url "https://github.com/ariloytynoja/prank-msa/raw/v.251117/binaries/prank.source.251117.tgz"
  sha256 "d8a2165b001d89506e75bb28c1a3fbdc39e32b06ceb865da2e6fffe976844c95"
  head "https://github.com/ariloytynoja/prank-msa.git", branch: "master"

  # The GitHub source is a nested binaries/ tarball tagged v.251117, a
  # non-standard date tag that autobump can't map to the version.
  livecheck do
    skip "GitHub source is a nested tarball under a non-standard date tag"
  end

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
    # Upstream ships an inconsistent binary version inside the dated tarball
    # (the 251117 archive reports "v.250331"), so assert on stable help text
    # rather than the formula version.
    assert_match "Minimal usage", shell_output("#{bin}/prank -help 2>&1")
  end
end
