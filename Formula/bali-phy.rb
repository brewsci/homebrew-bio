class BaliPhy < Formula
  # cite Redelings_2014: "https://dx.doi.org/10.1093/molbev/msu174"
  # cite Redelings_2021: "https://doi.org/10.1093/bioinformatics/btab129"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "https://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy.git",
    tag:      "4.1",
    revision: "1fd88e6ebe99a8e32cba486cb324740ca3a343d7"
  license "GPL-2.0-or-later"
  head "https://github.com/bredelings/BAli-Phy.git", branch: "master"

  #  livecheck do
  #    url :stable
  #    strategy :github_latest
  #  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "9fc996bdac09b7f758991a3ae495781d70fe81db6b8cbdf2750a941aad77da8c"
    sha256 cellar: :any,                 arm64_sonoma:  "82d0cb3e8a1b08975f03a52e33ea7374cfc05f303b17422ea72f4c380a34a134"
    sha256 cellar: :any,                 ventura:       "a6aefbd1ecba93eced72470d933cdb6aec5ca4a537c3daebbf89ad930f66d384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6e6dc84ff4d7727efc4754a8744f8beab4a714cbd3955046c4c8f7489aecb06"
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
