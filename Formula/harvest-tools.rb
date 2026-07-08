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
    rebuild 4
    sha256 cellar: :any, arm64_tahoe:   "a75b5756486208e482f5a6d4d92f4890354638f7cdd2171708089421a84a213c"
    sha256 cellar: :any, arm64_sequoia: "03abdbab5ab2f6aa0e7dfb94fb72f5209b4c3b332d90a46161903d3a2f010a8e"
    sha256 cellar: :any, arm64_sonoma:  "624b43a65d6d3dcf3e5f2f35ad948cd6b3bff9859448ea1eb99e282836406e84"
    sha256               x86_64_linux:  "232ef0368152c24fe1e57a5aaa2a82a7cc0c62501d74e16fb2adc26833d94eb9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "abseil"
  depends_on "capnp"
  depends_on "protobuf"
  uses_from_macos "zlib"
  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    inreplace "configure.ac", "-std=c++11", "-std=c++17"
    inreplace "Makefile.in", "-std=c++11", "-std=c++17"
    inreplace "Makefile.in", "-mmacosx-version-min=10.7", "-mmacosx-version-min=10.14" if OS.mac?
    inreplace "src/harvest/HarvestIO.cpp", "SetTotalBytesLimit(INT_MAX, INT_MAX)", "SetTotalBytesLimit(INT_MAX)"
    inreplace "Makefile.in", "-lpthread",
              "-lpthread -labsl_log_internal_check_op -labsl_log_internal_message"
    inreplace "Makefile.in", "-lpthread",
              "-lpthread -labsl_base -labsl_strings -labsl_synchronization"
    ENV.append "CXXFLAGS", "-L#{formula_opt_lib("abseil")}"
    # use dynamic libraries
    if OS.mac?
      inreplace "Makefile.in", ".a", ".dylib"
    else
      inreplace "Makefile.in", ".a", ".so"
    end
    system "autoreconf", "-fvi"
    args = [
      "--prefix=#{prefix}",
      "--with-protobuf=#{formula_opt_prefix("protobuf")}",
      "--with-capnp=#{formula_opt_prefix("capnp")}",
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
    assert_path_exists testpath/"out.ggr"
  end
end
