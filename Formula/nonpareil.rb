class Nonpareil < Formula
  # cite Rodriguez_2014: "https://doi.org/10.1093/bioinformatics/btt584"
  desc "Estimates coverage in metagenomic datasets"
  homepage "http://enve-omics.ce.gatech.edu/nonpareil"

  url "https://github.com/lmrodriguezr/nonpareil/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "41ea9c1378e85787142b29c7cdf8d352073764a620f818333492266e6bbec1cd"
  license "Artistic-2.0"
  head "https://github.com/lmrodriguezr/nonpareil.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "d10bbd4cb945d724a270691472c5e97c8354e4494b53666ee45b5c100809be4d"
    sha256 cellar: :any_skip_relocation, ventura:      "55d99f81cb3978924e85bf4eeaf9b03beb149ae7e8dc34af6edb887f41068e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dc80ce691025162aaa5911a64432822c49dcf9be4973db332e5cee9a5a04c4e3"
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
