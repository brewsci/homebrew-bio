class Unicycler < Formula
  # cite Wick_2017: "https://doi.org/10.1371/journal.pcbi.1005595"
  desc "Hybrid assembly pipeline for bacterial genomes"
  homepage "https://github.com/rrwick/Unicycler"
  url "https://github.com/rrwick/Unicycler/archive/v0.4.7.tar.gz"
  sha256 "a8cf65e46dc2694b0fbd4e9190c73a1f300921457aadfab27a1792b785620d63"
  license "GPL-3.0"
  revision 1
  head "https://github.com/rrwick/Unicycler.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "1100ca4a35cdef3a0c7b232d8e8418ee416ef74095b8fc28f8a4fccc6e4ab7ed" => :catalina
    sha256 "870cda34ffc8986c8bdb1b24707da593b6ffa0675627b73db644d0c13f999b66" => :x86_64_linux
  end

  depends_on "blast"
  depends_on "bowtie2"
  depends_on "brewsci/bio/pilon"
  depends_on "brewsci/bio/racon"
  depends_on "python@3.8"
  depends_on "samtools"
  depends_on "spades"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/unicycler --help")
  end
end
