class BaliPhy < Formula
  # cite Redelings_2014: "https://dx.doi.org/10.1093/molbev/msu174"
  # cite Redelings_2021: "https://doi.org/10.1093/bioinformatics/btab129"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "https://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy.git",
    tag:      "4.0-beta7",
    revision: "1d1403ae0dfb77e6a23bf2c091d6a3d66924e74b"
  license "GPL-2.0-or-later"
  head "https://github.com/bredelings/BAli-Phy.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 monterey:     "77e691f0d1f40b3af0a7748414c6be94842e8e03b848027f8cb3940dd011b5dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0d2e8b2dec53fd97c51b1953a75ae55ea22d80987072c745b851deeb95fb0813"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "gcc" unless OS.mac? # for C++20

  # C++20
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"
  fails_with gcc: "9"

  def install
    flags = %w[-C build install]
    system "meson", "build", "--prefix=#{prefix}", "--buildtype=release", "-Db_ndebug=true"
    system "ninja", *flags
  end

  test do
    system "#{bin}/bali-phy", "--version"
    system "#{bin}/bali-phy", "#{doc}/examples/5S-rRNA/5d.fasta", "--iter=150"
  end
end
