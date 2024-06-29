class Nonpareil < Formula
  # cite Rodriguez_2014: "https://doi.org/10.1093/bioinformatics/btt584"
  desc "Estimates coverage in metagenomic datasets"
  homepage "http://enve-omics.ce.gatech.edu/nonpareil"

  url "https://github.com/lmrodriguezr/nonpareil/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "0b38cfd16931b6005992d3c902aaa91943fbf67f67a64c5c0b9ed6a419e7ec90"
  license "Artistic-2.0"
  head "https://github.com/lmrodriguezr/nonpareil.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "bc566819e555df1f2d78612647642e45cd52953514baf66f3412c797407bce9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "89f6054e0ac0294ff44a5abfe61db24e7c3b6a440435fac058cec1bdc9f51af0"
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
    libexec.install "test/test.fasta.gz"
    libexec.install "test/test.fastq.gz"
  end

  def r_major_minor
    `#{Formula["r"].bin}/Rscript -e 'cat(as.character(getRversion()[1,1:2]))'`.strip
  end

  test do
    cp libexec/"test.fasta.gz", testpath
    cp libexec/"test.fastq.gz", testpath
    system bin/"nonpareil", "-s", "#{testpath}/test.fasta.gz",
                            "-T", "alignment", "-f", "fasta", "-X", "50",
                            "-b", "#{testpath}/test"
    system bin/"nonpareil", "-s", "#{testpath}/test.fastq.gz", "-T", "kmer",
                            "-b", "#{testpath}/test", "-X", "50", "-f", "fastq", "-X", "50"
    if build.with? :"open-mpi"
      system "mpirun", "-c", 1, bin/"nonpareil-mpi",
                       "-s", "#{testpath}/test.fasta.gz", "-T", "alignment",
                       "-b", "#{testpath}/test", "-f", "fasta", "-X", "50"
    end
  end
end
