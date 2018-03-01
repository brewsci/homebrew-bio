class Mash < Formula
  # cite Ondov_2016: "https://doi.org/10.1186/s13059-016-0997-x"
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  url "https://github.com/marbl/Mash/archive/v2.0.tar.gz"
  sha256 "7bea8cd3c266640bbd97f2e1c9d0168892915c1c14f7d03a9751bf7a3709dd01"
  revision 1
  head "https://github.com/marbl/Mash.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "cfbc688abc97975c8f79accc32ea1ab9a68cd612b758223f91078aa4db0140ca" => :sierra_or_later
    sha256 "554f45f0a0d3eab1eb119dd510039e1f85c64e0581de8de625ab5ced35d5596b" => :x86_64_linux
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
