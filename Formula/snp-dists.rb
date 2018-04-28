class SnpDists < Formula
  desc "Pairwise SNP distance matrix from a FASTA sequence alignment"
  homepage "https://github.com/tseemann/snp-dists"
  url "https://github.com/tseemann/snp-dists/archive/v0.6.tar.gz"
  sha256 "7e412de31e60bfe7ea51f67e92dba9e6cac5d1d12326522015b26407ddaca483"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "d0e37f7a33e36a820ddb46e0af783717c4837c43f5ee54c190b321d0e4334069" => :sierra_or_later
    sha256 "1986143fb403d25687158d3024d47ffa63b019780bef4cbd1ede0b5dbb7abd17" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    exe = "snp-dists"
    system "make"
    system "make", "check"
    bin.install exe
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snp-dists -v")
    assert_match "matrix", shell_output("#{bin}/snp-dists -h")
    assert_match ",seq1,seq2,seq3,seq4", shell_output("#{bin}/snp-dists -q -b -c #{pkgshare}/test/good.aln")
  end
end
