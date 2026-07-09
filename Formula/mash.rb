class Mash < Formula
  # cite Ondov_2016: "https://doi.org/10.1186/s13059-016-0997-x"
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  url "https://github.com/marbl/Mash/archive/refs/tags/v2.3.tar.gz"
  sha256 "f96cf7305e010012c3debed966ac83ceecac0351dbbfeaa6cd7ad7f068d87fe1"
  head "https://github.com/marbl/Mash.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "bdc8f1586a09dcaf7335cebd347191793b75af51f01c64ab62a19b4d5797367c"
    sha256 cellar: :any, arm64_sequoia: "da6fc8836979d4ec04f1f71a9f7ba4bc1009ab1b002baedf04686014f9ca3b48"
    sha256 cellar: :any, arm64_sonoma:  "f0ac8c56532a6fbb4a3dfb8c149e0c55ef2fa452cab91833c6837eb6e9bd58c1"
    sha256 cellar: :any, x86_64_linux:  "eb3ff44642522fae9fdf40f9b60b2a81f5655fb301249b45abc4c66b96cb4131"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "capnp"
  depends_on "gsl"

  uses_from_macos "zlib"
  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # newer GCC needs explicit <cstdint> (uintN_t) and <limits> (numeric_limits)
    ENV.append "CXXFLAGS", "-include cstdint -include limits"
    system "./bootstrap.sh"
    system "./configure",
      "--prefix=#{prefix}",
      "--with-capnp=#{formula_opt_prefix("capnp")}",
      "--with-gsl=#{formula_opt_prefix("gsl")}"
    system "make"
    system "make", "test"

    # ideally we should be using "make install" here
    bin.install "mash"
    doc.install Dir["doc/sphinx/*"]
    pkgshare.install "data", "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mash --version 2>&1")
    system bin/"mash", "sketch", "-o", "test", pkgshare/"data/genome1.fna"
    File.exist?("test.msh")
    assert_match "Sketches:", shell_output("#{bin}/mash info test.msh")
  end
end
