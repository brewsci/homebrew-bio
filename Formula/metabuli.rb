class Metabuli < Formula
  # cite van Kim_2024: "https://doi.org/10.1038/s41592-024-02273-y""
  desc "Specific and sensitive metagenomic classification"
  homepage "https://github.com/steineggerlab/Metabuli"
  url "https://github.com/steineggerlab/Metabuli/archive/refs/tags/1.0.8.tar.gz"
  sha256 "cc7e496ff82f00b56ef59aa2a04fa572a2025225b0558e0df144f166fade82d4"
  license "GPL-3.0-or-later"
  head "https://github.com/steineggerlab/Metabuli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "75e2588b17eb85a8db7ab1b59c2aab66c156a8912644b98dbc648a03340f345c"
    sha256 cellar: :any_skip_relocation, ventura:      "1b110d073d1cccc55b67fc70024bf9e122080e06267c079bd41cd000cd4347c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "93348547d2a71880d608e6f5d9ed0c57f31bf1baf7a056d5ae4cc5d517a65d97"
  end

  depends_on "cmake" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = []
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
    pkgshare.install "data"
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/steineggerlab/Metabuli-regression/archive/de07988ae1310d2fa2d0fec68409484c5ca652d8.tar.gz"
      sha256 "2d6faf0f00e38387b4a5bf76aa11e3a9d21707b679fcbf314e0fe70496398a9a"
    end
    resource("homebrew-testdata").stage testpath
    system "./run_regression.sh", bin/"metabuli", "tmp"
  end
end
