class StadenIoLib < Formula
  desc "Staden Package io_lib"
  homepage "https://staden.sourceforge.io/"
  url "https://github.com/jkbonfield/io_lib/releases/download/io_lib-1-14-11/io_lib-1.14.11.tar.gz"
  sha256 "a172cb66416794fdd9c1fc443f722f7e3439b52c99510b9a60f828392b9989e4"
  head "https://github.com/jkbonfield/io_lib.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9466bcd62e1a1cf4fe17361a43e220704df0a1069bc3243e8494e46af960af65" => :sierra
    sha256 "194a6acbe5fb3024bcc73dc35a4781309c69901d841f901fae280d72a5183267" => :x86_64_linux
  end

  depends_on "xz"

  unless OS.mac?
    depends_on "bzip2"
    depends_on "curl"
    depends_on "zlib"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    pkgshare.install "tests"
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
