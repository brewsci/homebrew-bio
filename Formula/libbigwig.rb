class Libbigwig < Formula
  desc "C library for processing the big UCSC fomats"
  homepage "https://github.com/dpryan79/libBigWig"
  url "https://github.com/dpryan79/libBigWig/archive/0.4.4.tar.gz"
  sha256 "43a2298b2ebadc48103447a3bb4426df1b38d1bec5fa564e50ed2f00cc060478"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "6c8853bfae2b374bfb6949036cb64b39667dfb5a5b1be9c92bcb61df867931b2" => :sierra
    sha256 "46011c89b465d546b60c616d7510be4c615b2836e3781000f7c721b95cb48ed9" => :x86_64_linux
  end

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
