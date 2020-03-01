class SnpDists < Formula
  desc "Pairwise SNP distance matrix from a FASTA sequence alignment"
  homepage "https://github.com/tseemann/snp-dists"
  url "https://github.com/tseemann/snp-dists/archive/v0.7.0.tar.gz"
  sha256 "9f5ae3c48f7c6c59b3132c445fbd6ea9269896a4c588171624adb1a7bb016b57"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "ecf4b205064a9e0615daacbc364cdc47ad1e984f4c50e9dc84fc9a757103381a" => :sierra
    sha256 "dd3920a797e2d8aa378cd5242cc532dcd7dc46307c6aa2ba1c3d36ae36e7d8c7" => :x86_64_linux
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
