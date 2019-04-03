class Nthits < Formula
  desc "Identifying repeats in high-throughput sequencing data"
  homepage "https://github.com/bcgsc/ntHits"
  url "https://github.com/bcgsc/ntHits/archive/ntHits-v0.0.1.tar.gz"
  sha256 "33d32d2607b9bd87055c381e6584b85a191a89a4b3c7d03921cfcb3c12d30797"
  head "https://github.com/bcgsc/ntHits.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gcc" if OS.mac? # for openmp

  fails_with :clang # needs openmp

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/nthits --help 2>&1")
  end
end
