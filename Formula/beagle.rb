class Beagle < Formula
  # cite Ayres_2011: "https://doi.org/10.1093/sysbio/syr100"
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/v3.0.0.tar.gz"
  sha256 "05140ac1f777cc69d6271223970642801edf538f191006271c3606420d3c5c3c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e21b7007657a3267538115c5b6c69d0a638a0fb1635c0ea08260754a742b6871" => :sierra_or_later
    sha256 "ecd81ffb7b8e5d4f56fff480c42039cff46798ab214a980639b6d4299057df03" => :x86_64_linux
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
