class Nonpareil < Formula
  # cite Rodriguez_2014: "https://doi.org/10.1093/bioinformatics/btt584"
  desc "Estimates coverage in metagenomic datasets"
  homepage "http://enve-omics.ce.gatech.edu/nonpareil"

  url "https://github.com/lmrodriguezr/nonpareil/archive/v3.3.4.tar.gz"
  sha256 "d91e83b3017fbafadf974355e32305d3896847ea3b671d5d98c553f01018f806"
  license "Artistic-2.0"
  head "https://github.com/lmrodriguezr/nonpareil.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "bc566819e555df1f2d78612647642e45cd52953514baf66f3412c797407bce9c" => :catalina
    sha256 "89f6054e0ac0294ff44a5abfe61db24e7c3b6a440435fac058cec1bdc9f51af0" => :x86_64_linux
  end

  depends_on "r"
  depends_on "open-mpi" => :optional

  def install
    r_library = lib/"R"/r_major_minor
    r_library.mkpath
    inreplace "Makefile", "CMD INSTALL", "CMD INSTALL --library=#{r_library}"
    system "make", "nonpareil"
    system "make", "nonpareil-mpi" if build.with? :"open-mpi"
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
    libexec.install "test/test.fasta"
  end

  def r_major_minor
    `#{Formula["r"].bin}/Rscript -e 'cat(as.character(getRversion()[1,1:2]))'`.strip
  end

  test do
    cp libexec/"test.fasta", testpath
    system bin/"nonpareil", "-s", "#{testpath}/test.fasta", "-T", "alignment",
                            "-b", "#{testpath}/test"
    system bin/"nonpareil", "-s", "#{testpath}/test.fasta", "-T", "kmer",
                            "-b", "#{testpath}/test", "-X", "50"
    if build.with? :"open-mpi"
      system "mpirun", "-c", 1, bin/"nonpareil-mpi",
                       "-s", "#{testpath}/test.fasta", "-T", "alignment",
                       "-b", "#{testpath}/test"
    end
  end
end
