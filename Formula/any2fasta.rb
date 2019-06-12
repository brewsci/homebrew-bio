class Any2fasta < Formula
  desc "Convert various sequence formats to FASTA"
  homepage "https://github.com/tseemann/any2fasta"
  url "https://github.com/tseemann/any2fasta/archive/v0.4.2.tar.gz"
  sha256 "e4cb2ddccda6298f5b0aee0c10184a75307a08b584d2abbfbf0d59d37b197e73"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "8d3d3f2b64992031b9c29c0d634003e744d70a0d9696fc815bd1349db27db405" => :sierra
    sha256 "56f513ec7e523f5fae592ecdd98ebeab235644c54025ad8597ee3163d00e24c7" => :x86_64_linux
  end

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
