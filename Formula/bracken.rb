class Bracken < Formula
  # cite Lu_2017: "https://doi.org/10.7717/peerj-cs.104"
  desc "Bayesian estimation species abundances from Kraken output"
  homepage "https://ccb.jhu.edu/software/bracken/index.shtml"
  url "https://github.com/jenniferlu717/Bracken/archive/v2.2.tar.gz"
  sha256 "307495060d3575c3a90c87cf82074d4a63d20cf4062658f161951c60a66fd319"

  depends_on "gcc" if OS.mac?

  fails_with :clang # uses OpenMP

  def install
    system "make", "-C", "src"

    inreplace "bracken", "$DIR/src", libexec
    inreplace "bracken-build", "$DIR/src", libexec

    bin.install "bracken", "bracken-build"
    libexec.install "src/est_abundance.py", "src/generate_kmer_distribution.py", "src/kmer2read_distr", "src/kreport2mpa.py"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/bracken -h 2> /dev/null")
  end
end
