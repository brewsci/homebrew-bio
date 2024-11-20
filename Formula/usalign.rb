class Usalign < Formula
  # cite Zhang_2022: "https://doi.org/10.1038/s41592-022-01585-1"
  desc "Universal structure alignment of monomeric, complex proteins and nucleic acids"
  homepage "https://github.com/pylelab/USalign"
  url "https://github.com/pylelab/USalign/archive/c39439c9b8ac81cc9717e709c9086b4adc3bab3d.tar.gz"
  version "20241114"
  sha256 "1a5727d9544ae0e841400945f2f5b6d58606475985369a600616d19ab7de1c20"
  license :cannot_represent
  head "https://github.com/pylelab/USalign.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa2d1940916e07affebf007286c2ecea8fcbfe5cb100bd91dafe938abac868aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50fff5666a463bee953ec170dc725b693d103a136384a476cbecff74fbb5ccc8"
    sha256 cellar: :any_skip_relocation, ventura:       "8c5ce97da451235a32dbeebea3f3bb9f6d4b5cfea5205bb4f2d84e888d9370f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83f8918a7f3fbfc01250c7ae08eaa276711f211f1459cf227b596e0e5703720c"
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
