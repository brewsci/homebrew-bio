class Mash < Formula
  # cite Ondov_2016: "https://doi.org/10.1186/s13059-016-0997-x"
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  url "https://github.com/marbl/Mash/archive/v2.2.1.tar.gz"
  sha256 "c81c4d2cd85e3ff4f73017a51e000f58f6942b429ece0b9f7fa48e549bbcae1e"
  head "https://github.com/marbl/Mash.git"

  bottle do
    cellar :any
    sha256 "1ebabe10ad2a9a0799484f4af0c752bc2babbc9f234150bf665369806db37253" => :sierra
    sha256 "c6367106ddeeb0a96e1ad6ecd9b1495950c67458f94779e94445c561327229e1" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "capnp"
  depends_on "gsl"

  uses_from_macos "zlib"

  def install
    # wrong version string: https://github.com/marbl/Mash/issues/124
    inreplace "src/mash/version.h", "2.2", version.to_s

    system "./bootstrap.sh"
    system "./configure",
      "--prefix=#{prefix}",
      "--with-capnp=#{Formula["capnp"].opt_prefix}",
      "--with-gsl=#{Formula["gsl"].opt_prefix}"
    system "make"
    system "make", "test"

    # ideally we should be using "make install" here
    bin.install "mash"
    doc.install Dir["doc/sphinx/*"]
    pkgshare.install "data", "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mash --version 2>&1")
    system bin/"mash", "sketch", "-o", "test", pkgshare/"data/genome1.fna"
    File.exist?("test.msh")
    assert_match "Sketches:", shell_output("#{bin}/mash info test.msh")
  end
end
