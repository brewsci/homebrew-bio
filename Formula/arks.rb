class Arks < Formula
  # cite Coombe_2018: "https://doi.org/10.1186/s12859-018-2243-x"
  desc "Scaffold genome assemblies with 10x Genomics Chromium reads"
  homepage "https://github.com/bcgsc/arks"
  url "https://github.com/bcgsc/arks/archive/1.0.3.tar.gz"
  sha256 "036971694e36de68d1285e385804489d478e7668459cd2fffccf9f64cf0facef"
  head "https://github.com/bcgsc/arks.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

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
