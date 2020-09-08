class Jellyfish < Formula
  # cite Marcais_2011: "https://doi.org/10.1093/bioinformatics/btr011"
  desc "Fast, memory-efficient counting of DNA k-mers"
  homepage "http://www.genome.umd.edu/jellyfish.html"
  url "https://github.com/gmarcais/Jellyfish/releases/download/v2.3.0/jellyfish-2.3.0.tar.gz"
  sha256 "e195b7cf7ba42a90e5e112c0ed27894cd7ac864476dc5fb45ab169f5b930ea5a"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "54cda3e960e08fbf2120a13876ab6c47b0d583c3b043800281e4df14e58e4abc" => :catalina
    sha256 "2813f495b7438e162844005526ae6393f496ea5033a04e35192f33d7923e874d" => :x86_64_linux
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
