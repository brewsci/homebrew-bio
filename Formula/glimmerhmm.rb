class Glimmerhmm < Formula
  # cite Majoros_2004: "https://doi.org/10.1093/bioinformatics/bth315"
  desc "New gene finder based on a Generalized Hidden Markov Model"
  homepage "https://ccb.jhu.edu/software/glimmerhmm/"
  url "https://ccb.jhu.edu/software/glimmerhmm/dl/GlimmerHMM-3.0.4c.tar.gz"
  sha256 "31ee2ceb8f31338205b2de626d83d0f92d2cd55a04d48a6803193a2d0ad1b4a3"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "ab610b0f2686681869e6976f30ac58d3ff8f6526055ba7020f74435b51d50fca"
    sha256 cellar: :any_skip_relocation, ventura:      "6a81afa731017f6f7af7e51ebdbbc168f3172a62108e136626bcee762a224e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8e8d27f3d62f20079d27b651c95949b02daf0ca136bc691af79eaced0a661e34"
  end

  def install
    # fatal error: 'malloc.h' file not found
    inreplace %w[train/utils.cpp], "malloc.h", "stdlib.h"
    system "make", "-C", "sources"
    system "make", "-C", "train"
    bin.install "sources/glimmerhmm", "bin/glimmhmm.pl"
    prefix.install Dir["*"] - %w[bin sources]
  end

  test do
    system "#{bin}/glimmerhmm", "-h"
  end
end
