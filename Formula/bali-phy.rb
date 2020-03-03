class BaliPhy < Formula
  # cite Suchard_2006: "http://dx.doi.org/10.1093/bioinformatics/btl175"
  # cite Redelings_2014: "https://dx.doi.org/10.1093/molbev/msu174"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "http://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy/archive/3.5.0.tar.gz"
  sha256 "4938eacf1d07749d6d7ebbdbd151c7d634089c8178efc6bcbf70e7825de73409"
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
  depends_on "gcc@8" unless OS.mac? # for C++17

  # C++17
  fails_with :gcc => "5"
  fails_with :gcc => "6"
  fails_with :gcc => "7"

  def install
    flags = %w[-C build install]
    system "meson", "build", "--prefix=#{prefix}"
    system "ninja", *flags
  end

  test do
    system "#{bin}/bali-phy", "#{doc}/examples/sequences/5S-rRNA/5d.fasta", "--iter=150"
    system "#{bin}/bp-analyze", "5d-1"
  end
end
