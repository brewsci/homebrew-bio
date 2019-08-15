class Mash < Formula
  # cite Ondov_2016: "https://doi.org/10.1186/s13059-016-0997-x"
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  url "https://github.com/marbl/Mash/archive/v2.2.tar.gz"
  sha256 "7ad006dbf0d6ffc3e164713ba955aab4cd24eaf85c864ac905f48cd8ba332691"
  head "https://github.com/marbl/Mash.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "2f91a23b5a0aa948f5c388dae276bc47d4dcf5d204331fbb94c43ef2976fd562" => :sierra
    sha256 "1a939c40a533d2299f3b6b16e43c689634ef183b6f03c7850d8ef62ebcc0998f" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "capnp"
  depends_on "gsl"
  depends_on "zlib" unless OS.mac?

  def install
    system "./bootstrap.sh"
    system "./configure",
      "--prefix=#{prefix}",
      "--with-capnp=#{Formula["capnp"].opt_prefix}",
      "--with-gsl=#{Formula["gsl"].opt_prefix}"
    system "make"
    system "make", "test"

    bin.install "mash"
    doc.install Dir["doc/sphinx/*"]
    pkgshare.install "data", "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mash -h 2>&1")
    system bin/"mash", "sketch", "-o", "test", pkgshare/"data/genome1.fna"
    File.exist?("test.msh")
    assert_match "Sketches:", shell_output("#{bin}/mash info test.msh")
  end
end
