class Relion < Formula
  desc "Image-processing software for cryo-electron microscopy"
  homepage "https://github.com/3dem/relion"
  url "https://github.com/3dem/relion/archive/refs/tags/4.0.2.tar.gz"
  sha256 "7ccc941a6a885bd850efa8867ea908254d8dc260cf72cc24c375bb9f1d56bf91"
  license "GPL-2.0-only"
  head "https://github.com/3dem/relion.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "84926c8aaad2d9bdea40c944efb6d926c1409396564524712f9fb6d4449eed63"
    sha256 cellar: :any,                 arm64_sonoma:  "5268715bc5d704775cf6eef1f325647a2e2befb0d7a4e81bd588101d10ae7bf4"
    sha256 cellar: :any,                 ventura:       "6ec8acd5655ac980387848bf8b387072d48f4eb3a3c50b1e62c4e09c8bd8fee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bbb1e879709fcc299c5a09f91120008c7b443aadb35e8ef66e1c61cbb90bba7"
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
