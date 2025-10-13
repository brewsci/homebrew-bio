class Relion < Formula
  desc "Image-processing software for cryo-electron microscopy"
  homepage "https://github.com/3dem/relion"
  url "https://github.com/3dem/relion/archive/refs/tags/5.0.1.tar.gz"
  sha256 "acbf898e96513b092514a56ff2a255c69a795e7a6f04131eacc8f55e2a900c23"
  license "GPL-2.0-only"
  head "https://github.com/3dem/relion.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_tahoe:   "a3e668f02c173472c46fb5a56e1345c9fc0f8879497292805e324dd4cc3d0d00"
    sha256 cellar: :any,                 arm64_sequoia: "ae9cff4e093e2890858b195d17c3c9c7c0bc01fdd36f5b47f046135646655962"
    sha256 cellar: :any,                 arm64_sonoma:  "7a40c196f06b300e0c29d703fcb987ee32ab168bc0cebe9e5a75e4b61e2c2297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee283054e938fb4a4a3a5942f3938322c1d24f47e002d9d0329833e0e1cfcac1"
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
    args = []
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    args << "-DFETCH_TORCH_MODELS=OFF"
    args << "-DCUDA=OFF"
    args << "-DPYTHON_EXE_PATH=#{Formula["python@3.13"].opt_bin}/python3"
    args << "-DTORCH_HOME_PATH=#{Formula["pytorch"].opt_prefix}"
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
