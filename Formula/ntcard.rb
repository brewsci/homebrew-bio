class Ntcard < Formula
  # cite Mohamadi_2017: "https://doi.org/10.1093/bioinformatics/btw832"
  desc "Estimating k-mer coverage histogram of genomics data"
  homepage "https://github.com/bcgsc/ntCard"
  url "https://github.com/bcgsc/ntCard/archive/1.0.1.tar.gz"
  sha256 "f3f5969f2bc49a86d045749e49049717032305f5648b26c1be23bb0f8a13854a"
  revision 1
  head "https://github.com/bcgsc/ntCard"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "c2a4975d62ca60e7926dd78831aec208ad55bc77ab1f716c87bbdd541f500110" => :sierra_or_later
    sha256 "6d1fb4c956d57ae24466c44ace9a9523c3704fe8269e0367dde301a8d73ff422" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gcc" if OS.mac? # for openmp

  fails_with :clang # needs openmp

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ntcard --help 2>&1")
  end
end
