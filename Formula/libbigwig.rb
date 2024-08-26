class Libbigwig < Formula
  desc "C library for processing the big UCSC fomats"
  homepage "https://github.com/dpryan79/libBigWig"
  url "https://github.com/dpryan79/libBigWig/archive/refs/tags/0.4.7.tar.gz"
  sha256 "8e057797011d93fa00e756600898af4fe6ca2d48959236efc9f296abe94916d9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "1c3d147c015b265880a03545510b2a24361947da763ca353091b7a7adba49d33"
    sha256 cellar: :any,                 ventura:      "d1d171fafebe930795f7a5dc34a8e08c4256118c5dd2890bebbd669f57626bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "37b031e10b9c6de938c1004952fe08f890b5de817963821e3d977280aad2fb28"
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
