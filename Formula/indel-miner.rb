class IndelMiner < Formula
  desc "Indentify indels from BAM files"
  homepage "https://github.com/aakrosh/indelMINER"
  url "https://github.com/aakrosh/indelMINER/archive/v0.2.tar.gz"
  sha256 "572693242bad9ca302befccc7846233281e3f31ab06e38591d67b4a18297307b"

  unless OS.mac?
    depends_on "ncurses"
    depends_on "zlib"
  end

  def install
    cd "src" do
      system "make"
      bin.install "indelminer"
    end
    pkgshare.install "test_data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/indelminer -h")
    tdir = pkgshare/"test_data"
    assert_match "2998\t.\tTCAGGA\tT",
      shell_output("#{bin}/indelminer #{tdir}/reference.fa sample=#{tdir}/alignments.bam 2> /dev/null")
  end
end
