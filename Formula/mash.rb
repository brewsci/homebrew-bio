class Mash < Formula
  # cite Ondov_2016: "https://doi.org/10.1186/s13059-016-0997-x"
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  url "https://github.com/marbl/Mash/archive/v2.0.tar.gz"
  sha256 "7bea8cd3c266640bbd97f2e1c9d0168892915c1c14f7d03a9751bf7a3709dd01"
  revision 1
  head "https://github.com/marbl/Mash.git"

  bottle do
    cellar :any
    sha256 "a6533b182d4f0a600549f446562c43d315205952686aaa54270700d13e70305f" => :sierra
    sha256 "c99869b2652be4556b5b62ba83d291e541ee6d8b5db1d2d18350d4a3e5230c97" => :el_capitan
    sha256 "0e4fd774c5ef62ab1fe33c54164f26621951e0632bf8501957df8f49cd677c2f" => :x86_64_linux
  end

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
    bin.install "mash"
    doc.install Dir["doc/sphinx/*"]
    pkgshare.install "data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mash -h 2>&1")
    system bin/"mash", "sketch", "-o", "test", pkgshare/"data/genome1.fna"
    File.exist?("test.msh")
    assert_match "Sketches:", shell_output("#{bin}/mash info test.msh")
  end
end
