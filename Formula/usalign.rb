class Usalign < Formula
  # cite Zhang_2022: "https://doi.org/10.1038/s41592-022-01585-1"
  desc "Universal structure alignment of monomeric, complex proteins and nucleic acids"
  homepage "https://github.com/pylelab/USalign"
  url "https://github.com/pylelab/USalign/archive/609e718d19ee525f9c86a6e6b3b33243775cc011.tar.gz"
  version "20241201"
  sha256 "65d710c843a7e9ca853ebbd0c44dc1c31731c9721dc28931315216d9aa9b695a"
  license :cannot_represent
  head "https://github.com/pylelab/USalign.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd88e6192cc803c34b5d9b8d56a741c8689dba20c35c2671e9c337d89e8e9fd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31f1756960b991b0542431aaa547b72db45daf31cd7c238d3767c9b98b5ed3fa"
    sha256 cellar: :any_skip_relocation, ventura:       "01d5ce8595ff848cb8ce2426ee25a0fd8c30bb9aafe5582b35b133ddafc9868b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cbfade4415ac2eba48cfcecaa7bf573eb5f6c6d536beae398810ddac51077be"
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
