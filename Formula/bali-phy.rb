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
    sha256 cellar: :any, arm64_tahoe:   "ade38c42564fa5aafcb02a0f45ba58be5152fed0053e3d93a03d6e733cfffe35"
    sha256 cellar: :any, arm64_sequoia: "20e7a82d254fe8d58e490f7b2f56e54f254ba149613a131cf40b40191ae1fa11"
    sha256 cellar: :any, arm64_sonoma:  "154ecfddd30db92ebe10b52ad06dd22ddc4d9a50467fff81f1c525bd5e7eba80"
    sha256 cellar: :any, x86_64_linux:  "222265e830fd8473210c3a7bbc60654e015625ff9738d91cd3d1b60591927345"
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
