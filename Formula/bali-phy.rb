class BaliPhy < Formula
  # cite Suchard_2006: "http://dx.doi.org/10.1093/bioinformatics/btl175"
  # cite Redelings_2014: "https://dx.doi.org/10.1093/molbev/msu174"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "http://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy/archive/3.6.1.tar.gz"
  sha256 "6591f39d5708f5c34fca244f20326c6cba30bb32c80b72c6ae2e7e23bafcf11a"
  license "GPL-2.0-or-later"
  head "https://github.com/bredelings/BAli-Phy.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "be42fc5e484110a6ad5379ca889cb213788f647af30c0531945bd48d363c5355"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fe3b2a4ac7350c0172be7d30f67c7a742d6545c5e266a4ff9cf6290afa0a160d"
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
