class Nonpareil < Formula
  # cite Rodriguez_2014: "https://doi.org/10.1093/bioinformatics/btt584"
  desc "Estimates coverage in metagenomic datasets"
  homepage "http://enve-omics.ce.gatech.edu/nonpareil"

  url "https://github.com/lmrodriguezr/nonpareil/archive/v3.3.1.tar.gz"
  sha256 "6fc9caf915f80704876fcd7b0a1fb3beda664fdb840fa0866bdfa1cb76df1a34"
  head "https://github.com/lmrodriguezr/nonpareil.git"

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
