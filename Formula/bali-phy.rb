class BaliPhy < Formula
  # cite Suchard_2006: "http://dx.doi.org/10.1093/bioinformatics/btl175"
  # cite Redelings_2014: "https://dx.doi.org/10.1093/molbev/msu174"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "http://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy/archive/3.6.0.tar.gz"
  sha256 "88f1922f80d0376ec2a0929d72d69258eac3dfba0eef13aab3f9c460db1ac0b6"
  license "GPL-2.0-or-later"
  head "https://github.com/bredelings/BAli-Phy.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "ee924ade4462c55d1c7ef15f36746f827da87015a13950cc8be88856ad2eb9f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1e5e46ba81196fbb97b837cb2736fb57b64f40ceef4023a15f85b48de8efa1e8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gcc@9" unless OS.mac? # for C++17

  # C++17
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"

  def install
    flags = %w[-C build install]
    system "meson", "build", "--prefix=#{prefix}", "--buildtype=release", "-Db_ndebug=true"
    system "ninja", *flags
  end

  test do
    system "#{bin}/bali-phy", "--version"
    system "#{bin}/bali-phy", "#{doc}/examples/sequences/5S-rRNA/5d.fasta", "--iter=150"
    system "#{bin}/bp-analyze", "5d-1"
  end
end
