class SnpDists < Formula
  desc "Pairwise SNP distance matrix from a FASTA sequence alignment"
  homepage "https://github.com/tseemann/snp-dists"
  url "https://github.com/tseemann/snp-dists/archive/v0.2.tar.gz"
  sha256 "3deb6feb5d2b8c3588059fdfa14a94440957fe31f9da4f9c0c7e72113f2f52fc"
  head "https://github.com/tseemann/snp-dists.git"

  depends_on "zlib" unless OS.mac?

  def install
    exe = "snp-dists"
    system "make", exe
    bin.install exe
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snp-dists -v")
    assert_match "matrix", shell_output("#{bin}/snp-dists -h")
    assert_match ",seq1,seq2,seq3,seq4", shell_output("#{bin}/snp-dists -q -b -c #{pkgshare}/test/good.aln")
  end
end
