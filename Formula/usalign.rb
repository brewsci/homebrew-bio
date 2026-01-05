class Usalign < Formula
  # cite Zhang_2022: "https://doi.org/10.1038/s41592-022-01585-1"
  desc "Universal structure alignment of monomeric, complex proteins and nucleic acids"
  homepage "https://github.com/pylelab/USalign"
  url "https://github.com/pylelab/USalign/archive/ad9850eac4dbfa6634e9bc099ff31a70127db4bf.tar.gz"
  version "20250422"
  sha256 "bc6d49205d60cf46241140201d47b825ea53d9cb384ae50623a10fc489cbd56a"
  license :cannot_represent
  head "https://github.com/pylelab/USalign.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80da885a6cfcb7eb437afe5ddfbb9580df2eae285a58bc6e34fde9cab13a96f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b104b52f00167d4f7ba569cc926ec06db02c5af2dc74f4a6069470d7a4bd1435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d25860dcc565c9f12febe8bc4c5442beb43d994c0e584e350335053b261f021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcd17979bff992585e22bab7e6f1776b038358e649f1086fdafe0bb14bf73211"
  end

  def install
    binaries = %w[
      qTMclust
      USalign
      TMalign
      TMscore
      MMalign
      se
      pdb2xyz
      xyz_sfetch
      pdb2fasta
      pdb2ss
      NWalign
      HwRMSD
      cif2pdb
      pdbAtomName
      addChainID
    ]
    system "make"
    bin.install binaries
  end

  test do
    assert_match "usage", shell_output("#{bin}/USalign -h 2>&1")
  end
end
