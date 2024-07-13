class HarvestTools < Formula
  # cite Treangen_2014: "https://doi.org/10.1186/s13059-014-0524-x"
  desc "Utility for creating and interfacing with Gingr files"
  homepage "https://github.com/marbl/harvest-tools"
  url "https://github.com/marbl/harvest-tools/archive/refs/tags/v1.3.tar.gz"
  sha256 "ffbcf0a115c74507695fd6cee4a9d5ba27a700db36b32d226521ef8dd3309264"
  head "https://github.com/marbl/harvest-tools.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 sierra:       "bea665dabd577ff78847689683634e581ae160fa114c6236f1cebadac9ba28d7"
    sha256 x86_64_linux: "fd5f92ca90802aa2f5174b175d39aa72558f67ba2d199eacb22baf86ca2d9955"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "abseil"
  depends_on "capnp"
  depends_on "protobuf"

  uses_from_macos "zlib"

  def install
    inreplace "configure.ac", "-std=c++11", "-std=c++17"
    inreplace "Makefile.in", "-std=c++11", "-std=c++17"
    inreplace "src/harvest/HarvestIO.cpp", "SetTotalBytesLimit(INT_MAX, INT_MAX)", "SetTotalBytesLimit(INT_MAX)"
    inreplace "Makefile.in", "-lpthread",
              "-lpthread -labsl_log_internal_check_op -labsl_log_internal_message"
    inreplace "Makefile.in", "-lpthread",
              "-lpthread -labsl_base -labsl_strings -labsl_synchronization"
    ENV.append "CXXFLAGS", "-L#{Formula["abseil"].opt_lib}"
    # use dynamic libraries
    if OS.mac?
      inreplace "Makefile.in", ".a", ".dylib"
    else
      inreplace "Makefile.in", ".a", ".so"
    end
    system "autoreconf", "-fvi"
    args = [
      "--prefix=#{prefix}",
      "--with-protobuf=#{Formula["protobuf"].opt_prefix}",
      "--with-capnp=#{Formula["capnp"].opt_prefix}",
    ]
    system "./configure", *args
    system "make", "all"
    include.install "src/harvest"
    if OS.mac?
      lib.install "libharvest.dylib"
    else
      lib.install "libharvest.so"
    end
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
