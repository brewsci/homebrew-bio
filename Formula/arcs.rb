class Arcs < Formula
  # cite Yeo_2017: "https://doi.org/10.1093/bioinformatics/btx675"
  desc "Scaffold genome sequence assemblies using 10x Genomics data"
  homepage "https://github.com/bcgsc/arcs"
  url "https://github.com/bcgsc/arcs/releases/download/v1.2.1/arcs-1.2.1.tar.gz"
  sha256 "c86e2dae359b38bed0a628e60e47a95e496ac9ef0fbda712d9246e7f0332c832"
  license "GPL-3.0"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any, catalina:     "d683a22fb63e36d4cbcf11847b9700d85c454a90e77915615bcccae95d0c2475"
    sha256 cellar: :any, x86_64_linux: "84a56e57a9a1c904361dc2100e279a41f9992b208737061276cce50273df0ff9"
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
    depends_on "libomp"
  end

  def install
    on_macos do
      ENV.append "LDFLAGS", "-L#{Formula["libomp"].opt_lib} -lomp"
      ENV.append "CPPFLAGS", "-I#{HOMEBREW_PREFIX}/include -Xpreprocessor -fopenmp -lomp"
    end

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
