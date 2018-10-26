class Jellyfish < Formula
  # cite Marcais_2011: "https://doi.org/10.1093/bioinformatics/btr011"
  desc "Fast, memory-efficient counting of DNA k-mers"
  homepage "http://www.genome.umd.edu/jellyfish.html"
  url "https://github.com/gmarcais/Jellyfish/releases/download/v2.2.10/jellyfish-2.2.10.tar.gz"
  sha256 "8988550dfb30ca077c7ddf77d382b87d39749a2e95c0eb459d819bbddd6097cc"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "ab6db416d9178cd2706eb372eeeda55bfefd5efb0de2c2ac7353df098632e7c4" => :sierra
    sha256 "61f9f49af2c78c06cefb7752bd07ad27a46a7be511e3926d4e3bacbfd93c4303" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jellyfish", "--version"
  end
end
