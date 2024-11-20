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
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "627ed3a998c2d2205359929a724b9913f22e84f35a6c9d86c85233bb35801956"
    sha256 cellar: :any_skip_relocation, ventura:      "71e08efed94c5cfda83aa7fac49389d49ac45d112afc1066385b386fbfaced8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "19ff8e42faed17d5ff615d926c518dc4374f87584f4b3b40caeb7abadaa1c061"
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
