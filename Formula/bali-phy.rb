class BaliPhy < Formula
  # cite Suchard_2006: "http://dx.doi.org/10.1093/bioinformatics/btl175"
  # cite Redelings_2014: "https://dx.doi.org/10.1093/molbev/msu174"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "http://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy/archive/3.4.1.tar.gz"
  sha256 "d05575278025516729446243fb41ff8588cdfdfbaeaf4792148d5b2e45742c18"
  head "https://github.com/bredelings/BAli-Phy.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "0c05be48396fa1e0873af0131c8ef6870bffa2cdf59822e97310025d5bb937b3" => :sierra
    sha256 "14215c6ab69ba7cd03a9939b29f565daef502f33f7989b8989961a332574164f" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"

  def install
    flags = %w[-C build install]
    # Reduce memory usage for Circle CI
    flags << "-j4" if ENV["HOMEBREW_CIRCLECI"]
    system "meson", "build", "--prefix=#{prefix}"
    system "ninja", *flags
  end

  test do
    system "#{bin}/bali-phy", "--version"
    system "#{bin}/bali-phy", "#{doc}/examples/sequences/5S-rRNA/5d.fasta", "--iter=150"
    system "#{bin}/bp-analyze", "5d-1"
  end
end
