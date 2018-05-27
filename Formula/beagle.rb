class Beagle < Formula
  # cite Ayres_2011: "https://doi.org/10.1093/sysbio/syr100"
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/v3.0.1.tar.gz"
  sha256 "d94b3b440ea64c564005f4eadceff8d502129dd22369f6045e40121ca383a6ca"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f2a36b844012466bc3dadae10eb7252d5ece07f3022515879ca646e3fd1df34e" => :sierra_or_later
    sha256 "922195ec4f8e1ae5ce411067416bb6c5d7774d1fb5d470828e9edd09e8da4cd9" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build
  depends_on :java => :build unless OS.mac?

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--disable-silent-rules", "--without-cuda", "--disable-libtool-dev"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "libhmsbeagle/platform.h"
      int main()
      {
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}/libhmsbeagle-1",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
