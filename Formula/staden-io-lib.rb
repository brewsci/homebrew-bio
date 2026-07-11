class StadenIoLib < Formula
  desc "Staden Package io_lib"
  homepage "https://staden.sourceforge.io/"
  url "https://github.com/jkbonfield/io_lib/archive/refs/tags/io_lib-1-16-0.tar.gz"
  sha256 "2eeb5852378050aa5ca539a8680148f05d7ce52fa9c288224e7a0b698bd97068"
  head "https://github.com/jkbonfield/io_lib.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4cc0c0843a328ef4303c6653c5903a64b0b63334562b057b2b0dc409c3d9a2cd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "xz"
  depends_on "zlib-ng-compat"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  resource "htscodecs" do
    url "https://github.com/samtools/htscodecs/archive/5aecc6e107db1c2ff59529a5aa034d28b799b7d1.tar.gz"
    sha256 "32e630af98e1dd445ee9537c2ac5adbd3910195fd39a03e7912ee7ea201b5b74"
  end

  def install
    (buildpath/"htscodecs").install resource("htscodecs")
    system "./bootstrap"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-libdeflate=#{formula_opt_prefix("libdeflate")}",
                          "--with-zstd=#{formula_opt_prefix("zstd")}",
                          "--with-htslib=#{formula_opt_prefix("htslib")}",
                          "--prefix=#{prefix}"
    system "make", "install"

    pkgshare.install "tests"

    # Avoid references to Homebrew shims
    inreplace pkgshare/"tests/Makefile", HOMEBREW_LIBRARY/"Homebrew/shims/linux/super/", "/usr/bin/" if OS.linux?
  end

  test do
    (testpath/"test.sam").write <<~EOS
      @SQ	SN:xx	LN:30
      a0	16	xx	4	1	10H	*	0	0	*	*
    EOS

    (testpath/"test.c").write <<~EOS
      #include "io_lib/scram.h"
      int main(int argc, char** argv) {
        scram_fd* fd = scram_open("test.sam", "r");
        if (fd == NULL) return 1;
        scram_close(fd);
        return 0;
      }
    EOS

    system ENV.cc, "-o", "staden-io-lib-test", testpath/"test.c", "-L#{lib}", "-lstaden-read"
    system "./staden-io-lib-test"
  end
end
