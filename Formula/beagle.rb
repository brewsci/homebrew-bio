class Beagle < Formula
  # cite Ayres_2011: "https://doi.org/10.1093/sysbio/syr100"
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/beagle_release_2_1_2.tar.gz"
  sha256 "82ff13f4e7d7bffab6352e4551dfa13afabf82bff54ea5761d1fc1e78341d7de"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "11813a2b5ba8f7d9823bf022b39a2ab8b08304ad0ec6ab773c2cf4223fef6815" => :sierra_or_later
    sha256 "d54b6f619fa74482163b5b56d1b9a1ab6f173e8c7e1b0dfa4bc92867bf96377f" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build

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
