class Mrbayes < Formula
  # cite Ronquist_2003: "https://doi.org/10.1093/bioinformatics/btg180"
  desc "Bayesian inference of phylogenies and evolutionary models"
  homepage "https://nbisweden.github.io/MrBayes/"
  url "https://github.com/NBISweden/MrBayes/archive/v3.2.7a.tar.gz"
  sha256 "3eed2e3b1d9e46f265b6067a502a89732b6f430585d258b886e008e846ecc5c6"
  license "GPL-3.0"
  head "https://github.com/NBISweden/MrBayes.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, sierra:       "55f858faa19f1073cc030c19be1feb1cc154e6baaf3c8905f0953ba013385e08"
    sha256 cellar: :any, x86_64_linux: "832051f9fbdb0557e2c3a483907b78723f1c1114ab42c8dcc1f804ff2eaa6376"
  end

  depends_on "beagle"
  depends_on "readline"
  depends_on "open-mpi" => :optional

  def install
    system "./configure",
      "--prefix=#{prefix}",
      "--with-mpi=#{build.with?("open-mpi") ? "yes" : "no"}"
    system "make"
    system "make", "install"

    doc.install share/"examples/mrbayes" => "examples"
  end

  test do
    cp doc/"examples/primates.nex", testpath
    cmd = "mcmc ngen = 50000; sump; sumt;"
    cmd = "set usebeagle=yes beagledevice=cpu;" + cmd if build.with? "beagle"
    inreplace "primates.nex", "end;", cmd + "\n\nend;"
    system bin/"mb", "primates.nex"
  end
end
