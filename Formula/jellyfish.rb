class Jellyfish < Formula
  # cite Marcais_2001: "https://doi.org/10.1093/bioinformatics/btr011"
  desc "Fast, memory-efficient counting of DNA k-mers"
  homepage "http://www.genome.umd.edu/jellyfish.html"
  url "https://github.com/gmarcais/Jellyfish/releases/download/v2.2.9/jellyfish-2.2.9.tar.gz"
  sha256 "854511d06f04cc2a8459d3f171862381d98430494194ff6f1970d1ffb74c80a8"

  depends_on "pkg-config" => :build

  depends_on "htslib"
  depends_on "samtools"
  
  depends_on :linux

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jellyfish --version")
  end
end
