class Mash < Formula
  # cite Ondov_2016: "https://doi.org/10.1186/s13059-016-0997-x"
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  url "https://github.com/marbl/Mash/archive/v2.2.2.tar.gz"
  sha256 "e4c2d702fd0254f689256b2d8f7d3cc3a68db3ea45b60f0a662ce926a4f5fc22"
  head "https://github.com/marbl/Mash.git"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "b4b6433a2f48079e6859725c0ec1ec0a90c16739428aa4c32d54a9c16d325df9" => :sierra
    sha256 "e54b02acda44a3cd66f4e731fa6dc50a2133a213d686e602c639bf49074f97bd" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "capnp"
  depends_on "gsl"

  uses_from_macos "zlib"

  def install
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
