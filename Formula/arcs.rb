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
    sha256 "0015ed6dfafcad4c001fa2db63b6cd9c93cf768dcc2103ed3901222b14855e89" => :sierra_or_later
    sha256 "140ea9634bd9ec54eeaa41e69e502f7bd928dce7423d4f39687820a0ff4aa3c0" => :x86_64_linux
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
