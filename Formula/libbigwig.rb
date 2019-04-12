class Libbigwig < Formula
  desc "C library for processing the big UCSC fomats"
  homepage "https://github.com/dpryan79/libBigWig"
  url "https://github.com/dpryan79/libBigWig/archive/0.4.2.tar.gz"
  sha256 "c32c655bf6e383226f76fd4052e0371848a274bc14502a0fe1b851b6d901c85b"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "6c8853bfae2b374bfb6949036cb64b39667dfb5a5b1be9c92bcb61df867931b2" => :sierra
    sha256 "46011c89b465d546b60c616d7510be4c615b2836e3781000f7c721b95cb48ed9" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "curl"
    depends_on "zlib"
  end

  def install
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
