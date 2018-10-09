class Any2fasta < Formula
  desc "Convert various sequence formats to FASTA"
  homepage "https://github.com/tseemann/any2fasta"
  url "https://github.com/tseemann/any2fasta/archive/v0.4.2.tar.gz"
  sha256 "e4cb2ddccda6298f5b0aee0c10184a75307a08b584d2abbfbf0d59d37b197e73"

  def install
    bin.install "any2fasta"
    pkgshare.install Dir["test.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/any2fasta -v")
    t = pkgshare/"test"
    assert_match "Wrote 75", shell_output("#{bin}/any2fasta -l #{t}.gbk 2>&1 > /dev/null")
    assert_match "Wrote 226", shell_output("#{bin}/any2fasta -u #{t}.gff 2>&1 > /dev/null")
    assert_match "Wrote 24", shell_output("#{bin}/any2fasta -n #{t}.fna 2>&1 > /dev/null")
  end
end
