class Exabayes < Formula
  # cite Aberer_2014: "https://doi.org/10.1093/molbev/msu236"
  desc "Large-scale Bayesian tree inference"
  homepage "https://sco.h-its.org/exelixis/web/software/exabayes/"
  url "https://sco.h-its.org/exelixis/resource/download/software/exabayes-1.5.tar.gz"
  sha256 "e401f1b4645e67e8879d296807131d0ab79bba81a1cd5afea14d7c3838b095a2"
  head "https://github.com/aberer/exabayes.git", :branch => "devel"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "77fda7581253a180c1ccd75db4e160ca1be097a2884946efe292c7307e401db4" => :sierra
    sha256 "739036d04fcb054c2456b8148a9667e80636a3e1b5b03dcee1d1add9dc2c6464" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "open-mpi" => :recommended

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]
    args = %W[--disable-dependency-tracking --disable-silent-rules --prefix=#{prefix}]
    args << "--enable-mpi" if build.with? "open-mpi"
    system "autoreconf", "--install" if build.head?
    system "./configure", *args
    system "make", "date" if build.head?

    # Only build the binaries; `make` by itself will also
    # build the manual which requires a full TeX installation.
    progs = %w[yggdrasil parser-exabayes sdsf postProcParam credibleSet extractBips consense exabayes]
    system "make", *progs
    bin.install *progs
    pkgshare.install "examples"
  end

  test do
    (testpath/"config.nex").write <<~EOS
      #nexus
      begin run;
        numgen 10000
        numruns 2
        numcoupledchains 2
        convergencecriterion none
      end;
    EOS

    (testpath/"aln.phy").write <<~EOS
       10 60
      Cow       ATGGCATATCCCATACAACTAGGATTCCAAGATGCAACATCACCAATCATAGAAGAACTA
      Carp      ATGGCACACCCAACGCAACTAGGTTTCAAGGACGCGGCCATACCCGTTATAGAGGAACTT
      Chicken   ATGGCCAACCACTCCCAACTAGGCTTTCAAGACGCCTCATCCCCCATCATAGAAGAGCTC
      Human     ATGGCACATGCAGCGCAAGTAGGTCTACAAGACGCTACTTCCCCTATCATAGAAGAGCTT
      Loach     ATGGCACATCCCACACAATTAGGATTCCAAGACGCGGCCTCACCCGTAATAGAAGAACTT
      Mouse     ATGGCCTACCCATTCCAACTTGGTCTACAAGACGCCACATCCCCTATTATAGAAGAGCTA
      Rat       ATGGCTTACCCATTTCAACTTGGCTTACAAGACGCTACATCACCTATCATAGAAGAACTT
      Seal      ATGGCATACCCCCTACAAATAGGCCTACAAGATGCAACCTCTCCCATTATAGAGGAGTTA
      Whale     ATGGCATATCCATTCCAACTAGGTTTCCAAGATGCAGCATCACCCATCATAGAAGAGCTC
      Frog      ATGGCACACCCATCACAATTAGGTTTTCAAGACGCAGCCTCTCCAATTATAGAAGAATTA
    EOS

    args = build.with?("open-mpi") ? %W[mpirun -np 2 #{bin}/exabayes] : %W["#{bin}/yggdrasil -T 2]
    args += %w[-f aln.phy -m DNA -n test -s 100 -c config.nex]
    system *args
    system "#{bin}/sdsf", "-f", "ExaBayes_topologies.run-0.test", "ExaBayes_topologies.run-1.test"
    system "#{bin}/consense", "-n", "cons", "-f", "ExaBayes_topologies.run-0.test", "ExaBayes_topologies.run-1.test"
  end
end
