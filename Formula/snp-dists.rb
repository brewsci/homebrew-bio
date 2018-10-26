class SnpDists < Formula
  desc "Pairwise SNP distance matrix from a FASTA sequence alignment"
  homepage "https://github.com/tseemann/snp-dists"
  url "https://github.com/tseemann/snp-dists/archive/v0.6.tar.gz"
  sha256 "7e412de31e60bfe7ea51f67e92dba9e6cac5d1d12326522015b26407ddaca483"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "87755e5d9549aa51ede1f0ef1eee7a2a5a59a5a24d2c7488cee629bc1a9e7cb3" => :sierra
    sha256 "1e4807d3ce60a2e8fe0e20252e0500cfe78bf2ebefa0498f7edf701756f6f449" => :x86_64_linux
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
