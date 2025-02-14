class BaliPhy < Formula
  # cite Redelings_2014: "https://dx.doi.org/10.1093/molbev/msu174"
  # cite Redelings_2021: "https://doi.org/10.1093/bioinformatics/btab129"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "https://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy.git",
    tag:      "4.0-beta17",
    regision: "33285a20bf37b12fa61344d36fb1668c850b43d0"
  license "GPL-2.0-or-later"
  head "https://github.com/bredelings/BAli-Phy.git", branch: "master"

  #  livecheck do
  #    url :stable
  #    strategy :github_latest
  #  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "a2c9894f3692d271daf9e7caeb9a2b8b379a8b5175d9106d166a38a5817f0b51"
    sha256 cellar: :any,                 ventura:      "dad1175ce693d81e3764702a98e55b30020dc043fa07644e80118883e5ff003a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cfdcbf2c55478c05fbfd9ea91a1ade34a0cee6874bf721f7cf3864f16d1119d2"
  end

  depends_on "eigen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "gcc" unless OS.mac? # for C++20

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1300
  end

  fails_with :clang do
    build 1300
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20 support"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++" if OS.mac? && DevelopmentTools.clang_build_version <= 1300
    ENV["BOOST_ROOT"] = Formula["boost"].opt_prefix

    flags = %w[-C build install]
    system "meson", "build", "--prefix=#{prefix}", "--buildtype=release", "-Db_ndebug=true"
    system "ninja", *flags
  end

  test do
    system "#{bin}/bali-phy", "--version"
    system "#{bin}/bali-phy", "#{doc}/examples/5S-rRNA/5d.fasta", "--iter=150"
    system "#{bin}/bp-analyze", "5d-1"
  end
end
