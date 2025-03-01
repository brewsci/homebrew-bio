class BaliPhy < Formula
  # cite Redelings_2014: "https://dx.doi.org/10.1093/molbev/msu174"
  # cite Redelings_2021: "https://doi.org/10.1093/bioinformatics/btab129"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "https://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy.git",
    tag:      "4.0",
    revision: "6cb702d708600ebfdff41829e8be2ed9f033d336"
  license "GPL-2.0-or-later"
  head "https://github.com/bredelings/BAli-Phy.git", branch: "master"

  #  livecheck do
  #    url :stable
  #    strategy :github_latest
  #  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "a8b56beacf0ac70244798f041fc47370315bf4bb3368d3c3e0550b726982470c"
    sha256 cellar: :any,                 arm64_sonoma:  "706a28714411d0f47df75b0ed7d5ea757781d26f7e9bda698508df3849e299ee"
    sha256 cellar: :any,                 ventura:       "7466cb303c0e14ea29df1a81018b06fc4ab82b79567d2fd5e46972868046db2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8195aca549207e85a206fbaaa9917d927a8dd0bbb267ddc3356b9335e41e37f9"
  end

  depends_on "cereal" => :build
  depends_on "eigen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "range-v3" => :build

  depends_on "boost"
  depends_on "cairo"
  depends_on "fmt"
  depends_on "gcc" unless OS.mac? # for C++20

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20 support"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++" if OS.mac? && DevelopmentTools.clang_build_version <= 1500
    ENV["BOOST_ROOT"] = Formula["boost"].opt_prefix

    flags = %w[install -C build]
    system "meson", "setup", "build", "--prefix=#{prefix}", "--buildtype=release", "-Db_ndebug=true"
    system "meson", *flags
  end

  test do
    system "#{bin}/bali-phy", "--version"
    system "#{bin}/bali-phy", "#{doc}/examples/5S-rRNA/5d.fasta", "--iter=150"
    system "#{bin}/bp-analyze", "5d-1"
  end
end
