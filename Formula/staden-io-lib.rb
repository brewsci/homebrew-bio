class StadenIoLib < Formula
  desc "Staden Package io_lib"
  homepage "https://staden.sourceforge.io/"
  url "https://github.com/jkbonfield/io_lib/archive/refs/tags/io_lib-1-15-0.tar.gz"
  sha256 "7006ab127ec05649d1f1bceafb7953defc665408da24cf990804d2c65e510f39"
  head "https://github.com/jkbonfield/io_lib.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4cc0c0843a328ef4303c6653c5903a64b0b63334562b057b2b0dc409c3d9a2cd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libdeflate"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

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
                          "--with-libdeflate=#{Formula["libdeflate"].opt_prefix}",
                          "--with-zstd=#{Formula["zstd"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make", "install"

    pkgshare.install "tests"

    # Avoid references to Homebrew shims
    os = OS.mac? ? "mac" : "linux"
    inreplace pkgshare/"tests/Makefile", HOMEBREW_LIBRARY/"Homebrew/shims/#{os}/super/", "/usr/bin/"
    rm pkgshare/"tests/cram_io_test"
  end

  test do
    (testpath/"test.sam").write <<~EOS
      @SQ  SN:xx  LN:30
      a0  16  xx  4  1  10H  *  0  0  *  *
    EOS

    (testpath/"test.c").write <<~EOS
      #include "io_lib/scram.h"
      int main(int argc, char** argv) {
        cram_fd* cramfd = cram_io_open("test.sam","rc","rb");
        if (CRAM_IO_SEEK(cramfd,0,SEEK_END) == 0) return 0;
        else return 1;
      }
    EOS

    system ENV.cc, "-o", "staden-io-lib-test", testpath/"test.c", "-L#{lib}", "-lstaden-read"
    system "./staden-io-lib-test"
  end
end
