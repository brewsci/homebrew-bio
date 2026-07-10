class Mash < Formula
  # cite Ondov_2016: "https://doi.org/10.1186/s13059-016-0997-x"
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  url "https://github.com/marbl/Mash/archive/refs/tags/v2.3.tar.gz"
  sha256 "f96cf7305e010012c3debed966ac83ceecac0351dbbfeaa6cd7ad7f068d87fe1"
  license "BSD-3-Clause"
  head "https://github.com/marbl/Mash.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "ffa139172215d17096a1180601ee6a11092f576e77202b1116a1b2f1fb38c9d1"
    sha256 cellar: :any, arm64_sequoia: "1a7d45e92cb4e4bccb72816b4e2e55f0f7b53a60826422ed7651739c64e96d66"
    sha256 cellar: :any, arm64_sonoma:  "662a8306fe60d19984f3f2ed2f21253559206f629377ea99be7302825df95af4"
    sha256 cellar: :any, x86_64_linux:  "866a60d8900de1fdcdf2f383dcf723b975598ed29461f873f31fba8b7073d29a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "capnp"
  depends_on "gsl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Newer compilers need explicit <cstdint>/<limits> includes, and the
    # bundled build pins -std=c++14 while the current Cap'n Proto requires C++17.
    ENV.append "CXXFLAGS", "-include cstdint -include limits"
    inreplace ["Makefile.in", "configure.ac"], "-std=c++14", "-std=c++17"
    # Drop the glibc-symbol-pinning memcpy wrapper: it forces memcpy@GLIBC_2.2.5,
    # which the Homebrew toolchain does not provide (Homebrew targets its own glibc).
    inreplace "Makefile.in", " -include src/mash/memcpyLink.h -Wl,--wrap=memcpy", ""
    inreplace "Makefile.in", "-include src/mash/memcpyLink.h", ""
    system "./bootstrap.sh"
    system "./configure", *std_configure_args,
                          "--with-capnp=#{formula_opt_prefix("capnp")}",
                          "--with-gsl=#{formula_opt_prefix("gsl")}"
    system "make"
    bin.install "mash"
    doc.install Dir["doc/sphinx/*"]
    pkgshare.install "data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mash --version 2>&1")
    system bin/"mash", "sketch", "-o", "test", pkgshare/"data/genome1.fna"
    assert_match "Sketches:", shell_output("#{bin}/mash info test.msh")
  end
end
