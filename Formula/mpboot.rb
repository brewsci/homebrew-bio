class Mpboot < Formula
  # cite Hoang_2018: "https://doi.org/10.1186/s12862-018-1131-3"
  desc "Fast maximum parsimony tree inference and bootstrap approximation"
  homepage "http://www.iqtree.org/mpboot/"
  url "http://www.iqtree.org/mpboot/mpboot-1.1.0-Source.tar.gz"
  sha256 "164ceb7839b7fc7fa81ee44ee4b2fd4921fd9389f860f2132a3d19e9e37fa61f"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9f81b4335359b8427fee1737fca2939f63ff62cc0f03097302c9837a99736fdd" => :catalina
    sha256 "1b0598dc6c2b93a62554e4d5189fb2a5b683f0e812706e7c9a4f61c9fcd227fb" => :x86_64_linux
  end

  option "with-avx", "Enable AVX SIMD instructions instead of SSE4"

  depends_on "cmake" => :build
  depends_on "gcc" if OS.mac? # needs openmp

  fails_with :clang # needs openmp

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    # https://github.com/diepthihoang/mpboot/issues/1
    inreplace "CMakeLists.txt",
              'install (FILES "${PROJECT_SOURCE_DIR}/examples/example.phy" DESTINATION .)',
              "#"

    mkdir "build" do
      simd = build.with?("avx") ? "avx" : "sse4"
      system "cmake", "..", "-DIQTREE_FLAGS=#{simd}", *std_cmake_args
      system "make"
      system "make", "install"
      mv bin/"mpboot-avx", bin/"mpboot" if simd == "avx"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpboot -v 2>&1")
  end
end
