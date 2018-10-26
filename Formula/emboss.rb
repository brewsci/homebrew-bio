class Emboss < Formula
  # cite Rice_2000: "https://doi.org/10.1016/S0168-9525(00)02024-2"
  desc "European Molecular Biology Open Software Suite"
  homepage "https://emboss.sourceforge.io/"
  url "ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-6.6.0.tar.gz"
  mirror "http://mirrors.mit.edu/gentoo-distfiles/distfiles/EMBOSS-6.6.0.tar.gz"
  mirror "https://science-annex.org/pub/emboss/EMBOSS-6.6.0.tar.gz"
  sha256 "7184a763d39ad96bb598bfd531628a34aa53e474db9e7cac4416c2a40ab10c6e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "57219a42bac24b44d5d1ae5f9eb4f24039f984f23235f3cbcd589980289131a4" => :sierra
    sha256 "dd11bf961d44c707a75be24535d8bac8e1fa2eaf6d983888e185d8723e6c798c" => :x86_64_linux
  end

  depends_on "libtool"    => :build
  depends_on "pkg-config" => :build

  depends_on "gd"
  depends_on "libharu"
  depends_on "libpng"
  depends_on "zlib" unless OS.mac?

  depends_on "mysql"      => :optional
  depends_on "postgresql" => :optional
  depends_on :x11         => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --docdir=#{doc}
      --enable-64
      --with-thread
    ]
    args << "--without-x" if build.without? "x11"
    args << "--with-mysql" if build.with? "mysql"
    args << "--with-postgresql" if build.with? "postgresql"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "5\n", shell_output("#{bin}/seqcount -auto -filter #{share}/EMBOSS/test/data/tranalign.pep")
  end
end
