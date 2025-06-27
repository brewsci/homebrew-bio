class Arks < Formula
  # cite Coombe_2018: "https://doi.org/10.1186/s12859-018-2243-x"
  desc "Scaffold genome assemblies with 10x Genomics Chromium reads"
  homepage "https://github.com/bcgsc/arks"
  url "https://github.com/bcgsc/arks/archive/v1.0.4.tar.gz"
  sha256 "bb99a2e2adc988605a19b2f1cfcd6300ba392ac9697efc22c2b2b77de2b13711"
  head "https://github.com/bcgsc/arks.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, sierra:       "9a3c4628f6b9cdb438082551316ff918c2eacfe2fb303766b652e6daede6a537"
    sha256 cellar: :any, x86_64_linux: "e862be3388e4dc1731de0d3d9e2836a0f5538fa71a11092f5e8edfab4c603d6c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on "gcc" if OS.mac? # needs openmp

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    inreplace "configure.ac", "AM_INIT_AUTOMAKE", "AM_INIT_AUTOMAKE(foreign)"
    inreplace "autogen.sh", "automake -a", "automake -ac"
    system "./autogen.sh"
    system "./configure",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_include}"
    system "make", "install"
    doc.install "Examples"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/arks --help")
  end
end
