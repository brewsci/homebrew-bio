class Dehomopolymerate < Formula
  desc "Pairwise SNP distance matrix from a FASTA sequence alignment"
  homepage "https://github.com/tseemann/dehomopolymerate"
  url "https://github.com/tseemann/dehomopolymerate/archive/v0.3.tar.gz"
  sha256 "659778bc7cd8e52a92f1547b5a93e71bf8022f62208313d06aec454aad9e91d6"

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    system "make", "test"
    bin.install "dehomopolymerate"
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dehomopolymerate -v")
    assert_match "seqs=7", shell_output("#{bin}/dehomopolymerate #{pkgshare}/test/test.fq.gz 2>&1")
  end
end
