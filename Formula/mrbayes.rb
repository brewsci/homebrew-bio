class Mrbayes < Formula
  # cite Ronquist_2003: "https://doi.org/10.1093/bioinformatics/btg180"
  desc "Bayesian inference of phylogenies and evolutionary models"
  homepage "https://mrbayes.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mrbayes/mrbayes/3.2.6/mrbayes-3.2.6.tar.gz"
  sha256 "f8fea43b5cb5e24a203a2bb233bfe9f6e7f77af48332f8df20085467cc61496d"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "a74e4e1ea82efca6bfca5efe791940bffe167467a121a417b770823bebe66039" => :sierra
    sha256 "de35643f5dc2c6f2234aed0d121b5446688fda285d0ecdd450a0258afc728717" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "beagle" => :recommended
  depends_on "open-mpi" => :recommended

  def install
    args = ["--disable-debug", "--prefix=#{prefix}"]
    args << "--with-beagle=" + (build.with?("beagle") ? Formula["beagle"].opt_prefix : "no")
    args << "--enable-mpi="  + (build.with?("open-mpi") ? "yes" : "no")

    cd "src" do
      system "autoconf"
      system "./configure", *args
      system "make"
      bin.install "mb"
    end

    pkgshare.install ["documentation", "examples"]
  end

  test do
    cp pkgshare/"examples/finch.nex", testpath
    cmd = "mcmc ngen = 50000; sump; sumt;"
    cmd = "set usebeagle=yes beagledevice=cpu;" + cmd if build.with? "beagle"
    inreplace "finch.nex", "end;", cmd + "\n\nend;"
    system bin/"mb", "finch.nex"
  end
end
