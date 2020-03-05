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
    cellar :any_skip_relocation
    sha256 "ee924ade4462c55d1c7ef15f36746f827da87015a13950cc8be88856ad2eb9f9" => :catalina
    sha256 "1e5e46ba81196fbb97b837cb2736fb57b64f40ceef4023a15f85b48de8efa1e8" => :x86_64_linux
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
    system "meson", "build", "--prefix=#{prefix}", "--buildtype=release"
    system "ninja", *flags
  end

  test do
    system "#{bin}/bali-phy", "--version"
    system "#{bin}/bali-phy", "#{doc}/examples/sequences/5S-rRNA/5d.fasta", "--iter=150"
    system "#{bin}/bp-analyze", "5d-1"
  end
end
