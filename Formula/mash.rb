class Mash < Formula
  # cite Ondov_2016: "https://doi.org/10.1186/s13059-016-0997-x"
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  url "https://github.com/marbl/Mash/archive/v2.1.tar.gz"
  sha256 "38ed8483d7c650ef580c54ca4f8158068248b25aedab19f92eeaea153a4fb534"
  head "https://github.com/marbl/Mash.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6a0a4fd38b7c1a895c069cb8284d5b4e36bb24b8a9a2d1cbf690089c3da385eb" => :sierra
    sha256 "a58327d0e7aa76f763a9e6e9c77fd0ae8b82302eb115797f75f0595d09992e01" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "capnp"
  depends_on "gsl"
  depends_on "zlib" unless OS.mac?

  needs :cxx14

  def install
    # https://github.com/marbl/Mash/issues/98
    inreplace "configure.ac", "c++11", "c++14"
    inreplace "Makefile.in", "c++11", "c++14"

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
