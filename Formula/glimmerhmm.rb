class Glimmerhmm < Formula
  # cite Majoros_2004: "https://doi.org/10.1093/bioinformatics/bth315"
  desc "New gene finder based on a Generalized Hidden Markov Model"
  homepage "https://ccb.jhu.edu/software/glimmerhmm/"
  url "https://ccb.jhu.edu/software/glimmerhmm/dl/GlimmerHMM-3.0.4c.tar.gz"
  sha256 "31ee2ceb8f31338205b2de626d83d0f92d2cd55a04d48a6803193a2d0ad1b4a3"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c03ef44f842231d97b7249a1c4b928310634e0b6fe7b8c75d84798caf1e1a1cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46de2a7bfdea26080567a6c2a001ac4f6473be2325a25cc33a4304ad42324e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7ae70a02359397849ecfccf607b5b0c7d5040580608b9702387e81c7e5eecfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "538a107e45669e7959ffa732084dcc725e1eb75694b0d61219201fcf07f0ba7f"
  end

  def install
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
