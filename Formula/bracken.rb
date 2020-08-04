class Bracken < Formula
  # cite Lu_2017: "https://doi.org/10.7717/peerj-cs.104"
  desc "Bayesian estimation species abundances from Kraken output"
  homepage "https://ccb.jhu.edu/software/bracken/index.shtml"
  url "https://github.com/jenniferlu717/Bracken/archive/v2.6.0.tar.gz"
  sha256 "fb1837d6f32b8f8c87353b9dc8a23d3418c348b00824a7064eb58f9bab11ea68"
  license "GPL-3.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "2f5ff6fb14b5bd5a787ded1a7a5fb996e8f85786feb75434a4433f5d5830ec9a" => :catalina
    sha256 "523af87b62653b651851715eced5ae3584e5bd0bb970b69f65fd126c865077f5" => :x86_64_linux
  end

  depends_on "gcc" if OS.mac? # needs openmp

  fails_with :clang # needs openmp

  def install
    system "make", "-C", "src"

    inreplace "bracken", "$DIR/src", libexec
    inreplace "bracken-build", "$DIR/src", libexec

    bin.install "bracken", "bracken-build"
    libexec.install "src/est_abundance.py",
                    "src/generate_kmer_distribution.py",
                    "src/kmer2read_distr",
                    "src/kreport2mpa.py"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/bracken -h 2> /dev/null")
  end
end
