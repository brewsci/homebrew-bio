class Arcs < Formula
  # cite Yeo_2017: "https://doi.org/10.1093/bioinformatics/btx675"
  desc "Scaffold genome sequence assemblies using 10x Genomics data"
  homepage "https://github.com/bcgsc/arcs"
  url "https://github.com/bcgsc/arcs/archive/v1.0.2.tar.gz"
  sha256 "ad8a168fe3f4ebbb4212fab8222228c70eca4fb19c83fbc335be35297bd0bbbb"
  head "https://github.com/bcgsc/arcs.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "9b3132d685bcb8f8438507e32198c58f68f7c479675c174788f460e61964aaa4" => :sierra_or_later
    sha256 "fc751b87c3cc2e756e4966e262c3c49fde5e38d1d1c9e4a2f61f9b444af7c4e3" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "zlib" unless OS.mac?

  def install
    inreplace "autogen.sh", "automake -a", "automake -a --foreign"
    system "./autogen.sh"
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
