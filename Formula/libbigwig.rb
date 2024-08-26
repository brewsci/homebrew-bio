class Libbigwig < Formula
  desc "C library for processing the big UCSC fomats"
  homepage "https://github.com/dpryan79/libBigWig"
  url "https://github.com/dpryan79/libBigWig/archive/refs/tags/0.4.7.tar.gz"
  sha256 "8e057797011d93fa00e756600898af4fe6ca2d48959236efc9f296abe94916d9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, sierra:       "3513fd0a41b0bf1409cb8f1e5ce9113811ece9d48c34a1a8cb2d734122d1c531"
    sha256 cellar: :any, x86_64_linux: "f85dc5dd0b892d1bcaeb4bec2623085f3a15e73adc115aa2fac119889d42131e"
  end

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "libBigWig.so", "libBigWig.dylib" if OS.mac?
    curl = Formula["curl"]
    system "make", "install", "prefix=#{prefix}", "INCLUDES=-I#{curl.opt_include}", "LDLIBS=-L#{curl.opt_lib}"
  end

  test do
    (testpath/"libbigwig.c").write <<~EOS
      #include "bigWig.h"
      #include <stdio.h>
      #include <inttypes.h>
      #include <stdlib.h>

      int main(int argc, char *argv[]) {
        if(bwInit(1<<17) != 0) {
          return 1;
        }
        return 0;
      }
    EOS
    libs = %w[-lBigWig]
    system ENV.cc, "-o", "test", "libbigwig.c", "-I#{include}", "-L#{lib}", *libs
    system "./test"
  end
end
