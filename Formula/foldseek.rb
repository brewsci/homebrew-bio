class Foldseek < Formula
  # cite van Kempen_2023: "https://doi.org/10.1038/s41587-023-01773-0"
  desc "Fast and sensitive comparisons of large protein structure sets"
  homepage "https://github.com/steineggerlab/foldseek"
  url "https://github.com/steineggerlab/foldseek/archive/refs/tags/9-427df8a.tar.gz"
  version "9-427df8a"
  sha256 "b17d2d85b49a8508f79ffd8b15e54afc5feef5f3fb0276a291141ca5dbbbe8bc"
  license "GPL-3.0-or-later"
  head "https://github.com/steineggerlab/foldseek.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "401fe7d71726287be0d95e173bb4b22cd2275b0544b81dc7037da3791627a636"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/steineggerlab/foldseek/master/example/d1asha_"
    sha256 "b4ec14f5decc94b5363b3414db4d25e3e09039c7a6fbb585041730dcf3cc1fd8"
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

    pkgshare.install "example"
  end

  test do
    resource("homebrew-testdata").stage testpath/"example"
    system bin/"foldseek", "easy-search", "example/d1asha_", "example", "aln", "tmpFolder"
    assert_equal "d1asha_\td1asha_\t1.000\t147\t0\t0\t1\t147\t1\t147\t1.011E-22\t1061\n", File.read("aln")
  end
end
