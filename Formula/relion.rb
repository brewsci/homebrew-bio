class Relion < Formula
  desc "Image-processing software for cryo-electron microscopy"
  homepage "https://github.com/3dem/relion"
  url "https://github.com/3dem/relion/archive/refs/tags/5.1.0.tar.gz"
  sha256 "4767804dd8ba2198efd1e1082b4632bc36aeca0ad09d4d2f7de956f84bbbb429"
  license "GPL-2.0-only"
  head "https://github.com/3dem/relion.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "f166e583997b5431b64333cb098a4c5cbf7d6878d64e2d3061ce4d140563ab10"
    sha256 cellar: :any, arm64_sequoia: "831c7b1f8997c654a6c6d9362a69214d9959bd50d32dba7718d67f868c63d844"
    sha256 cellar: :any, arm64_sonoma:  "3d0fa6cbdb4d18b6b1ae4c09f4e1a3b835ec3295c5510eb3b6e9366ebf281b81"
    sha256 cellar: :any, x86_64_linux:  "e5c1f73e7fa292a54a03e2172de95dc5b8cee0c1553bf659fa88c5a35b510a85"
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
