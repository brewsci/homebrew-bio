class Jellyfish < Formula
  # cite Marcais_2011: "https://doi.org/10.1093/bioinformatics/btr011"
  desc "Fast, memory-efficient counting of DNA k-mers"
  homepage "http://www.genome.umd.edu/jellyfish.html"
  url "https://github.com/gmarcais/Jellyfish/releases/download/v2.2.10/jellyfish-2.2.10.tar.gz"
  sha256 "8988550dfb30ca077c7ddf77d382b87d39749a2e95c0eb459d819bbddd6097cc"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jellyfish", "--version"
  end
end
