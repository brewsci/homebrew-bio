class Foldseek < Formula
  # cite van Kempen_2023: "https://doi.org/10.1038/s41587-023-01773-0"
  desc "Fast and sensitive comparisons of large protein structure sets"
  homepage "https://github.com/steineggerlab/foldseek"
  url "https://github.com/steineggerlab/foldseek/archive/refs/tags/10-941cd33.tar.gz"
  version "10-941cd33"
  sha256 "0db8bf072c9ec895efc6aa3626c746f4ca020acc9b92e9b2292b56c8c9f8a943"
  license "GPL-3.0-or-later"
  head "https://github.com/steineggerlab/foldseek.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "218a8174a6a0c47b8bf92d50e49e20531ac49adb59a10521a7b7885665b4d8cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22f58712af01d0b387c257d9f8524af8ae6250f4a70dad4e58fd5911c113897e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d23d2054d1ba68a32c4e07988fa16b8f1f7d2b7cd1e533569ac7089d6ee64cd1"
    sha256 cellar: :any,                 x86_64_linux:  "18fb78c11fb7b279a4eee326a5070eb90dde3781f93c3e26a8b0c8b3bc3c6ab5"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
    inreplace "CMakeLists.txt", "cmake_policy(SET CMP0060 OLD)", "cmake_policy(SET CMP0060 NEW)"

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
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/steineggerlab/foldseek/master/example/d1asha_"
      sha256 "b4ec14f5decc94b5363b3414db4d25e3e09039c7a6fbb585041730dcf3cc1fd8"
    end
    resource("homebrew-testdata").stage testpath/"example"
    system bin/"foldseek", "easy-search", "example/d1asha_", "example", "aln", "tmpFolder"
    assert_match(/^d1asha_\td1asha_\t1\.000\t147\t0\t0\t1\t147\t1\t147\t/, File.read("aln"))
  end
end
