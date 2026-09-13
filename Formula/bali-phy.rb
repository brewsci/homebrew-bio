class BaliPhy < Formula
  # cite Redelings_2014: "https://dx.doi.org/10.1093/molbev/msu174"
  # cite Redelings_2021: "https://doi.org/10.1093/bioinformatics/btab129"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "https://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy.git",
    tag:      "4.3",
    revision: "80b0402eed0157f31ecb57e0efc34c03ed83050c"
  license "GPL-2.0-or-later"
  head "https://github.com/bredelings/BAli-Phy.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "06ec1449c233d9e8df858bdaaf972c9b31efffc802847c9b1d12016746cd6826"
    sha256 cellar: :any, arm64_sequoia: "29a22a78e2ca5b65aac5e06c465d0af37238369a0c85096f1e3b4e52318edb31"
    sha256 cellar: :any, x86_64_linux:  "ddfd24cd20e5d6a318dbf870f008cfe0bdb65bc33c2d33998c54a47a18918af9"
  end

  depends_on "cereal" => :build
  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "range-v3" => :build

  depends_on "boost"
  depends_on "cairo"
  depends_on "fmt"
  depends_on "gcc" unless OS.mac? # for C++23
  depends_on "utf8proc"
  depends_on "xxhash"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version < 1600
  end

  fails_with :clang do
    build 1500
    cause "Requires C++23 support"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++23 support"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version < 1600
    ENV["CXX"] = formula_opt_bin("llvm")/"clang++" if OS.mac? && DevelopmentTools.clang_build_version < 1600
    ENV["BOOST_ROOT"] = formula_opt_prefix("boost")

    flags = %w[install -C build]
    system "meson", "setup", "build", "--prefix=#{prefix}", "--buildtype=release", "-Db_ndebug=true",
           "--wrap-mode=nodownload"
    system "meson", *flags
  end

  # Exercise installed model loading, MCMC, and report assets; version output alone misses these.
  test do
    system "#{bin}/bali-phy", "--version"
    system "#{bin}/bali-phy", "#{doc}/examples/5S-rRNA/5d.fasta", "--iterations=150", "--seed=12345"
    system "#{bin}/bpy-summarize", "5d-1"
    assert_path_exists testpath/"Results/index.html"
  end
end
