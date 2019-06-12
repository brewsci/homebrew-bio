class Libdivsufsort < Formula
  desc "Lightweight suffix-sorting library"
  homepage "https://github.com/y-256/libdivsufsort"
  url "https://github.com/y-256/libdivsufsort/archive/2.0.1.tar.gz"
  sha256 "9164cb6044dcb6e430555721e3318d5a8f38871c2da9fd9256665746a69351e0"
  head "https://github.com/y-256/libdivsufsort.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "d0b2553d3c658e81530f399f93c01044fe5de7f3924cc0058a57761095a31c4e" => :sierra
    sha256 "1f8809025776d0c921c65b0c89d9d9191120108d7d5103227e39444624623168" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-DBUILD_DIVSUFSORT64=1", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS
      #include <divsufsort.h>
      #include <stdio.h>
      int main() {
        const unsigned char s[] = "panamabananas";
        int sa[sizeof s];
        int i;
        divsufsort(s, sa, sizeof s);
        for (i = 0; i < sizeof s; ++i)
          printf(" %d", sa[i]);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldivsufsort", "-o", "test"
    assert_equal shell_output("./test"), " 13 5 3 1 7 9 11 6 4 2 8 10 0 12"
  end
end
