class Smalt < Formula
  desc "Aligns DNA sequencing reads with a reference genome"
  homepage "https://sourceforge.net/projects/smalt/"
  url "https://downloads.sourceforge.net/project/smalt/smalt-0.7.6.tar.gz"
  sha256 "89ccdfe471edba3577b43de9ebfdaedb5cd6e26b02bf4000c554253433796b31"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "ae0aab6ff80de21b408853efbfdd159f36f77d71927586baa27a88303a8ab97c"
    sha256 cellar: :any,                 arm64_sonoma:  "9d933821a8296501f9d1c6a72be228594185c90c3029ec3c288630f27dd45857"
    sha256 cellar: :any,                 ventura:       "c05d17307e0bf1b7e71eb0666f6eb7926f418e2158f2db201fe0b754f7352e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "209a0fd08ad7b70f2bba9b755de9d895242d90d17118b9d94139430ed79bc292"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "samtools"

  uses_from_macos "zlib"

  resource "bambamc" do
    url "https://github.com/gt1/bambamc/archive/refs/tags/0.0.50-release-20140430085950.tar.gz"
    sha256 "06d2f17b9e4290ef76275f5011dab3b9967baa4d960c2c42f315c7c2f8a89d04"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/smalt/smalt_manual.pdf"
    sha256 "efd52e8429237b27797027477c33e1071f6247616d7705106af256e48307480a"
  end

  def install
    resource("bambamc").stage do
      system "autoreconf", "-fvi"
      system "./configure", "--prefix=#{prefix}/bambamc"
      system "make", "install"
    end

    # add ldflags to find the libbambamc
    ldflags = "-Wl,-rpath -Wl,#{prefix}/bambamc/lib -L#{prefix}/bambamc/lib"
    args = std_configure_args + %W[
      --with-bambamc=yes
      PKG_CONFIG_PATH=#{prefix}/bambamc/lib/pkgconfig
      CFLAGS=-I#{prefix}/bambamc/include
      LDFLAGS=#{ldflags}
      LIBS=-lbambamc
    ]
    # No longer used -lbam in the latest samtools
    inreplace "configure", "-lbam", ""
    # Fix error: archive member 'libseq.a' not a mach-o file
    inreplace ["src/Makefile.am", "src/Makefile.in"], "libsgm_a_LIBADD = libseq.a", "libsgm_a_LIBADD = "
    system "./configure", *args
    system "make"
    system "make", "install"
    doc.install resource("manual")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smalt version")
  end
end
