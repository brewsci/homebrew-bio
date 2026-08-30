class Iqtree2 < Formula
  # cite Nguyen_2015: "https://doi.org/10.1093/molbev/msu300"
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  # pull from git tag to get submodules
  url "https://github.com/iqtree/iqtree2.git",
    tag:      "v2.4.0",
    revision: "977cc4324234b36fbfb80b326b8e43b73952e365"
  license "GPL-2.0-only"
  head "https://github.com/iqtree/iqtree2.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "043e5cfc7c1cffa7457165123a237ef38305f3960d86f015552f20d5a04d2b7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fcea6ddabffb2de66f26d5cb1fc31c37c21279db1eb1b0560f67669d3f65e84"
    sha256 cellar: :any_skip_relocation, ventura:       "9255796ac71623c8b774f1ad524b7e549f383a03d239bf3f6d44c20d96e3f294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a20021aa07edd77761cbfb6026d2fa2a20e813a919517803c6c450384c6a1986"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "gsl"   => :build
  depends_on "libomp" if OS.mac?
  depends_on "llvm" if OS.mac?
  uses_from_macos "zlib"

  # The bundled cmaple submodule fetches GoogleTest via CMake FetchContent,
  # which Homebrew blocks. Vendor the exact pinned source and point
  # FetchContent at it so no network access happens during the build.
  resource "googletest" do
    url "https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.tar.gz"
    sha256 "3dd5da4302b4069f90b2d58f48e6f3bc4c9938e024e7599241cafaebda476013"
  end

  def install
    (buildpath/"googletest").install resource("googletest")

    # The bundled prebuilt libomp.a (libmac*/) is stale and lacks newer
    # OpenMP runtime symbols (e.g. __kmpc_dispatch_deinit) that current
    # clang emits for dynamic-schedule loops, breaking the arm64 link of
    # decentTree. Drop it and link against Homebrew's up-to-date libomp.
    if OS.mac?
      Dir[buildpath/"libmac*/libomp.a"].each { |f| rm f }
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("libomp")}"
    end

    mkdir "build" do
      ENV.append_path "PREFIX_PATH", buildpath/"lsd2"
      system "cmake", "..", "-DEIGEN3_INCLUDE_DIR=#{formula_opt_include("eigen")}/eigen3",
             "-DFETCHCONTENT_SOURCE_DIR_GOOGLETEST=#{buildpath}/googletest",
             *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "boot", shell_output("#{bin}/iqtree2 -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/iqtree2 --version")
  end
end
