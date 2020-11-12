class Arcs < Formula
  # cite Yeo_2017: "https://doi.org/10.1093/bioinformatics/btx675"
  desc "Scaffold genome sequence assemblies using 10x Genomics data"
  homepage "https://github.com/bcgsc/arcs"
  url "https://github.com/bcgsc/arcs/releases/download/v1.1.1/arcs-1.1.1.tar.gz"
  sha256 "31422b10b57080f7058021d1c0ea6f38d3f255d4d82ca48d50f3f073d8c4792d"
  license "GPL-3.0"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "d683a22fb63e36d4cbcf11847b9700d85c454a90e77915615bcccae95d0c2475" => :catalina
    sha256 "84a56e57a9a1c904361dc2100e279a41f9992b208737061276cce50273df0ff9" => :x86_64_linux
  end

  head do
    url "https://github.com/bcgsc/arcs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build

  uses_from_macos "zlib"

  on_macos do
    depends_on "gcc@9" # needs openmp
  end

  fails_with :clang # needs openmp

  def install
    system "./autogen.sh" if build.head?
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-boost=#{Formula["boost"].opt_include}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/arcs --help")
  end
end
