class Unicycler < Formula
  # cite "https://doi.org/10.1371/journal.pcbi.1005595"
  desc "Hybrid assembly pipeline for bacterial genomes"
  homepage "https://github.com/rrwick/Unicycler"
  url "https://github.com/rrwick/Unicycler/archive/v0.4.3.tar.gz"
  sha256 "ddd446f4fc17094825878ce245bb885e5b6dfe9b607d4a3e32387bf3fc1ea969"
  head "https://github.com/rrwick/Unicycler/releases"

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
