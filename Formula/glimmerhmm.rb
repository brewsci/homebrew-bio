class Glimmerhmm < Formula
  # cite Majoros_2004: "https://doi.org/10.1093/bioinformatics/bth315"
  desc "New gene finder based on a Generalized Hidden Markov Model"
  homepage "https://ccb.jhu.edu/software/glimmerhmm/"
  url "https://ccb.jhu.edu/software/glimmerhmm/dl/GlimmerHMM-3.0.4c.tar.gz"
  sha256 "31ee2ceb8f31338205b2de626d83d0f92d2cd55a04d48a6803193a2d0ad1b4a3"
  revision 1

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
