class Mpboot < Formula
  # cite Hoang_2018: "https://doi.org/10.1186/s12862-018-1131-3"
  desc "Fast maximum parsimony tree inference and bootstrap approximation"
  homepage "http://www.iqtree.org/mpboot/"
  url "http://www.iqtree.org/mpboot/mpboot-1.1.0-Source.tar.gz"
  sha256 "164ceb7839b7fc7fa81ee44ee4b2fd4921fd9389f860f2132a3d19e9e37fa61f"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "c3a99c0519bec05893eb24bb4363906fc00a989c2055ef8620536cde08c60fa6" => :sierra
    sha256 "cd27e1c484da823dbf33b4e081c950b46aacfb3057af17552347bb3c011eba07" => :x86_64_linux
  end

  option "with-avx", "Enable AVX SIMD instructions instead of SSE4"

  depends_on "cmake" => :build
  depends_on "libomp" if OS.mac?

  def install
    libomp = Formula["libomp"]
    args = std_cmake_args
    args << "-DOpenMP_C_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
    args << "-DOpenMP_CXX_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
    args << "-DOpenMP_CXX_LIB_NAMES=omp"
    args << "-DOpenMP_C_LIB_NAMES=omp"
    args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
    args << "-DAPPLE_OUTPUT_DYLIB=ON"

    simd = build.with?("avx") ? "avx" : "sse4"
    args << "-DIQTREE_FLAGS=#{simd}"

    # https://github.com/diepthihoang/mpboot/issues/1
    inreplace "CMakeLists.txt",
              'install (FILES "${PROJECT_SOURCE_DIR}/examples/example.phy" DESTINATION .)',
              "#"

    # Fix clash with std::vector
    # https://github.com/diepthihoang/mpboot/pull/4
    inreplace "optimization.cpp", "vector", "vec"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
      mv bin/"mpboot-avx", bin/"mpboot" if simd == "avx"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpboot -v 2>&1")
  end
end
