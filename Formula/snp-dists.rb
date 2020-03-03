class SnpDists < Formula
  desc "Pairwise SNP distance matrix from a FASTA sequence alignment"
  homepage "https://github.com/tseemann/snp-dists"
  url "https://github.com/tseemann/snp-dists/archive/v0.7.0.tar.gz"
  sha256 "9f5ae3c48f7c6c59b3132c445fbd6ea9269896a4c588171624adb1a7bb016b57"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "642483d9173b5996dda4bd9676a99cd6b7e38f80352957bd19fc96be20ccd3ff" => :catalina
    sha256 "1e6bd8de0a2fc72365256c8b7ce8fcb2d3f53a108ecc719f57d417796ea45e5c" => :x86_64_linux
  end

  uses_from_macos "zlib"

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
