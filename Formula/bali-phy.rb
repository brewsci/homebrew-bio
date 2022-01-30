class BaliPhy < Formula
  # cite Suchard_2006: "http://dx.doi.org/10.1093/bioinformatics/btl175"
  # cite Redelings_2014: "https://dx.doi.org/10.1093/molbev/msu174"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "http://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy/archive/3.6.1.tar.gz"
  sha256 "6591f39d5708f5c34fca244f20326c6cba30bb32c80b72c6ae2e7e23bafcf11a"
  license "GPL-2.0-or-later"
  head "https://github.com/bredelings/BAli-Phy.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "272d54b06c0906e3fe6041c156d6fb748d0f2c27ff1c32d4271543fb302368a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4d1dd23a90021c9a833c0d7a51a454481eb862acfd832e7f53be5eeea5a36f1b"
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
