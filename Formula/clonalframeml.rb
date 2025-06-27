class Clonalframeml < Formula
  # cite Didelot_2015: "https://doi.org/10.1371/journal.pcbi.1004041"
  desc "Efficient Inference of Recombination in Bacterial Genomes"
  homepage "https://github.com/xavierdidelot/ClonalFrameML"
  url "https://github.com/xavierdidelot/ClonalFrameML/archive/v1.12.tar.gz"
  sha256 "ef76705c1a0f1343184f956cd0bdc96c2cfdbb998177330b09b6df84c74c2de6"
  license "GPL-3.0"
  head "https://github.com/xavierdidelot/ClonalFrameML.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "ef12d55ae473ef2e287e2e42d8b03631c938435ac6a58276e5afb20bd1df20d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "63567c0ed398baf544e83c62020169bf90790c5a1eb700678ad10a7ee42a5833"
  end

  def install
    system "make", "-C", "src"
    bin.install "src/ClonalFrameML"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ClonalFrameML -version 2>&1")
    assert_match "recombination", shell_output("#{bin}/ClonalFrameML -h 2>&1")
  end
end
