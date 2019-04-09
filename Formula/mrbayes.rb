class Mrbayes < Formula
  # cite Ronquist_2003: "https://doi.org/10.1093/bioinformatics/btg180"
  desc "Bayesian inference of phylogenies and evolutionary models"
  homepage "https://nbisweden.github.io/MrBayes/"
  url "https://github.com/NBISweden/MrBayes/archive/v3.2.7a.tar.gz"
  sha256 "3eed2e3b1d9e46f265b6067a502a89732b6f430585d258b886e008e846ecc5c6"
  head "https://github.com/NBISweden/MrBayes.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "a74e4e1ea82efca6bfca5efe791940bffe167467a121a417b770823bebe66039" => :sierra
    sha256 "de35643f5dc2c6f2234aed0d121b5446688fda285d0ecdd450a0258afc728717" => :x86_64_linux
  end

  depends_on "beagle"
  depends_on "readline"
  depends_on "open-mpi" => :optional

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-beagle="   + (build.with?("beagle")   ? Formula["beagle"].opt_prefix : "no")
    args << "--with-mpi="      + (build.with?("open-mpi") ? "yes" : "no")
    args << "--with-readline=" + (build.with?("readline") ? "yes" : "no")

    system "./configure", *args
    system "make"
    system "make", "install"

    mkdir pkgshare/"examples"
    mv share/"examples/mrbayes", pkgshare/"examples"
  end

  test do
    cp pkgshare/"examples/mrbayes/primates.nex", testpath
    cmd = "mcmc ngen = 50000; sump; sumt;"
    cmd = "set usebeagle=yes beagledevice=cpu;" + cmd if build.with? "beagle"
    inreplace "primates.nex", "end;", cmd + "\n\nend;"
    system bin/"mb", "primates.nex"
  end
end
