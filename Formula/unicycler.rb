class Unicycler < Formula
  # cite "https://doi.org/10.1371/journal.pcbi.1005595"
  desc "Hybrid assembly pipeline for bacterial genomes"
  homepage "https://github.com/rrwick/Unicycler"
  url "https://github.com/rrwick/Unicycler/archive/v0.4.4.tar.gz"
  sha256 "e25e7423119aec5e574324c403f8ae36d93c0ce1497853d42c1a49a2a924a1f4"
  head "https://github.com/rrwick/Unicycler/releases"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "7609477768912069a93d5a178e0b108bac57c19eef605658163486439ccc1565" => :sierra_or_later
    sha256 "de3ccc4f43e397cb07d251fad230f7c047879b2620b6c2cd9d1fdd1cbeb1396a" => :x86_64_linux
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
