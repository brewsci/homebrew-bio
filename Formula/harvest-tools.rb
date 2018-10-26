class HarvestTools < Formula
  # cite Treangen_2014: "https://doi.org/10.1186/s13059-014-0524-x"
  desc "Utility for creating and interfacing with Gingr files"
  homepage "https://github.com/marbl/harvest-tools"
  url "https://github.com/marbl/harvest-tools/archive/v1.3.tar.gz"
  sha256 "ffbcf0a115c74507695fd6cee4a9d5ba27a700db36b32d226521ef8dd3309264"
  head "https://github.com/marbl/harvest-tools.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "bea665dabd577ff78847689683634e581ae160fa114c6236f1cebadac9ba28d7" => :sierra
    sha256 "fd5f92ca90802aa2f5174b175d39aa72558f67ba2d199eacb22baf86ca2d9955" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "capnp"
  depends_on "protobuf"
  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}",
           "--with-protobuf=#{Formula["protobuf"].opt_prefix}",
           "--with-capnp=#{Formula["capnp"].opt_prefix}"
    system "make", "all"
    include.install "src/harvest"
    lib.install "libharvest.a"
    bin.install "harvesttools"
    pkgshare.install "test"
  end

  test do
    system "#{bin}/harvesttools", "-f", pkgshare/"test/test2.fna",
                                  "-x", pkgshare/"test/test2.xmfa",
                                  "-v", pkgshare/"test/test2.vcf",
                                  "-o", testpath/"out.ggr"
    assert_predicate testpath/"out.ggr", :exist?
  end
end
