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
    sha256 "c09abcc94a1520b8469de97c3b9ece1661ab6a13d8dd05c53c63f63dcf689e68" => :sierra_or_later
    sha256 "c73c13bed2d620983f71e0fa5cdddd6898eba6cb6aa820674a5b70a0f0f310f5" => :x86_64_linux
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
