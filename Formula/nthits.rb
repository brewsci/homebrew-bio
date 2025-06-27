class Nthits < Formula
  desc "Identifying repeats in high-throughput sequencing data"
  homepage "https://github.com/bcgsc/ntHits"
  url "https://github.com/bcgsc/ntHits/archive/ntHits-v0.0.1.tar.gz"
  sha256 "33d32d2607b9bd87055c381e6584b85a191a89a4b3c7d03921cfcb3c12d30797"
  license "MIT"
  head "https://github.com/bcgsc/ntHits.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, sierra:       "4d51d461f5bb9f4b18f43b5dae781f4f47906680968ea5249d0877ba453653bd"
    sha256 cellar: :any, x86_64_linux: "7c19716fbc5c4fe7709c4cbe14b2bc5f1cb7ec1f871dc956db2f380ca9d2cb74"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gcc" if OS.mac? # needs openmp

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
