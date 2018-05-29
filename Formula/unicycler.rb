class Unicycler < Formula
  # cite Wick_2017: "https://doi.org/10.1371/journal.pcbi.1005595"
  desc "Hybrid assembly pipeline for bacterial genomes"
  homepage "https://github.com/rrwick/Unicycler"
  url "https://github.com/rrwick/Unicycler/archive/v0.4.6.tar.gz"
  sha256 "56f6f358a5d1f8dd0fcd1df04504079fc42cec8453a36ee59ff89295535d03f5"
  head "https://github.com/rrwick/Unicycler/releases"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "371519d2cd3ab0aab5bc6a093446f5d5b185da90dbf3404bc2056aa2af9ae512" => :sierra_or_later
    sha256 "c7d704473906bd1e2ca56561d741dfae726f50248417d9c93f8586e74076cc5a" => :x86_64_linux
  end

  needs :cxx14

  depends_on "blast"
  depends_on "bowtie2"
  depends_on "pilon"
  depends_on "python"
  depends_on "racon"
  depends_on "samtools"
  depends_on "spades"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/unicycler --help")
  end
end
