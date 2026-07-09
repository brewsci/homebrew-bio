class Relion < Formula
  desc "Image-processing software for cryo-electron microscopy"
  homepage "https://github.com/3dem/relion"
  url "https://github.com/3dem/relion/archive/refs/tags/5.1.0.tar.gz"
  sha256 "4767804dd8ba2198efd1e1082b4632bc36aeca0ad09d4d2f7de956f84bbbb429"
  license "GPL-2.0-only"
  head "https://github.com/3dem/relion.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "1617f6a7c236e5cffd8a4ec7d9abef5bc23ddc6879e23e9362fb8b61a6e0ff79"
    sha256 cellar: :any, arm64_sequoia: "97043b1b420f5400e4eb9f67ba19d8f38be8abdaea992938aef087f2560e14e1"
    sha256 cellar: :any, arm64_sonoma:  "5e2cc2ebfc3309fac216755a892201d0b86151bb0fff32fee2efb9d2eda70d2f"
    sha256 cellar: :any, x86_64_linux:  "bb9ec9198eae86420ffe4563c26802219b31a3eb038aad303e841f58cc4cd7bc"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "fltk"
  depends_on "ghostscript"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libxft"
  depends_on "open-mpi"
  depends_on "pbzip2"
  depends_on "python@3.13"
  depends_on "pytorch"
  depends_on "xz"
  depends_on "zstd"

  on_macos do
    depends_on "libomp"
  end

  def install
    # relion 5.1.0 links relion_lib here with the plain target_link_libraries()
    # signature while every other call uses the PUBLIC keyword form; CMake
    # forbids mixing them. This only trips on macOS, where the formula sets
    # OpenMP_omp_LIBRARY (empty and thus a no-op on Linux).
    inreplace "src/apps/CMakeLists.txt",
              "target_link_libraries(relion_lib ${OpenMP_omp_LIBRARY})",
              "target_link_libraries(relion_lib PUBLIC ${OpenMP_omp_LIBRARY})"

    args = []
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    args << "-DFETCH_TORCH_MODELS=OFF"
    args << "-DCUDA=OFF"
    args << "-DPYTHON_EXE_PATH=#{formula_opt_bin("python@3.13")}/python3"
    args << "-DTORCH_HOME_PATH=#{formula_opt_prefix("pytorch")}"
    if OS.mac?
      libomp = Formula["libomp"]
      args << "-DOpenMP_C_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Done creating mask!", shell_output("#{bin}/relion_mask_create --denovo --box_size 10 2>&1").strip
    assert_match "(x,y,z,n)= 10 x 10 x 10 x 1", shell_output("#{bin}/relion_image_handler --stats --i mask.mrc").strip
  end
end
