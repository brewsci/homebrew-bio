class Relion < Formula
  desc "Image-processing software for cryo-electron microscopy"
  homepage "https://github.com/3dem/relion"
  url "https://github.com/3dem/relion/archive/refs/tags/4.0.1.tar.gz"
  sha256 "0ebbd94ad922d7f457e3f3b81f5660e2691a845d9a53f0f1c9fbeb4e54cd5c17"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/3dem/relion.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "fbfd85828db844e4f160755387ea9dd2336f86c5958643153b20bd07ed650e03"
    sha256 cellar: :any,                 ventura:      "4dea9b6e9acd66c0f3db5188580a7236a321a8f9768d55c6adbccd1d2f3a67ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8d0d927622f5b4313137068f97a05a19670b9f0bc1cf3b6090ef0817cc8c22a8"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "fltk"
  depends_on "ghostscript"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libxft"
  depends_on "open-mpi"
  depends_on "pbzip2"
  depends_on "xz"
  depends_on "zstd"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = []
    args << "-DFETCH_TORCH_MODELS=OFF"
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

    # Add Python shebang
    pyfile = bin/"relion_class_ranker.py"
    pylines = pyfile.read.lines
    pylines.unshift "#!/usr/bin/env python3\n"
    pyfile.atomic_write pylines.join
    chmod 0755, pyfile
  end

  test do
    assert_match "Done creating mask!", shell_output("#{bin}/relion_mask_create --denovo --box_size 10 2>&1").strip
    assert_match "(x,y,z,n)= 10 x 10 x 10 x 1", shell_output("#{bin}/relion_image_handler --stats --i mask.mrc").strip
  end
end
