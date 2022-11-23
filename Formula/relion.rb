class Relion < Formula
  desc "Image-processing software for cryo-electron microscopy"
  homepage "https://github.com/3dem/relion"
  url "https://github.com/3dem/relion/archive/refs/tags/4.0.0.tar.gz"
  sha256 "b52cfb75faf59ca4f702a77d206fdec18f1d97512eb7a1b6fd6a0eaca749c0f6"
  license "GPL-2.0-only"
  head "https://github.com/3dem/relion.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "fltk"
  depends_on "ghostscript"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libxft"
  depends_on "open-mpi"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = *std_cmake_args << "-DFETCH_TORCH_MODELS=OFF"
    if OS.mac?
      libomp = Formula["libomp"]
      args << "-DOpenMP_C_FLAGS=-Xpreprocessor\ -fopenmp\ -Wno-unused-command-line-argument\ -I#{libomp.opt_include}"
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor\ -fopenmp\ -Wno-unused-command-line-argument\ -I#{libomp.opt_include}"
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    assert_match "Done creating mask!", shell_output("#{bin}/relion_mask_create --denovo --box_size 10 2>&1").strip
    assert_match "mask.mrc : (x,y,z,n)= 10 x 10 x 10 x 1", shell_output("#{bin}/relion_image_handler --stats --i mask.mrc").strip
  end
end
