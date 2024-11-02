class Glimmerhmm < Formula
  # cite Majoros_2004: "https://doi.org/10.1093/bioinformatics/bth315"
  desc "New gene finder based on a Generalized Hidden Markov Model"
  homepage "https://ccb.jhu.edu/software/glimmerhmm/"
  url "https://ccb.jhu.edu/software/glimmerhmm/dl/GlimmerHMM-3.0.4c.tar.gz"
  sha256 "31ee2ceb8f31338205b2de626d83d0f92d2cd55a04d48a6803193a2d0ad1b4a3"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "847ba45276c06a6392f5bb368e90c6eae85bd709904038fd3a20798967ece052"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a9df390bd9612efcf5df20365fe7d13de548f0603bd7aa9aceee70419dfdb51"
    sha256 cellar: :any_skip_relocation, ventura:       "f3ad28ba64d112883ba62093aae37f649e9f53fa1b71807302e02bc4b064a52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39015836ca1dae579ac7dbb239d77f7915dfa8454b63d3a4f976f3ddaa18bff1"
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
