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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dd412d775cf30c54a10660d34bdde7d7831f2eae75265a8b223299f8e9f47ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fa969cf0115606a6732288a269e94ee2ec883081223a21a7f0792c58c67c1a8"
    sha256 cellar: :any_skip_relocation, ventura:       "d06bb40102fdb91449b6782f00f2f312f1fbda6206942376acca1d577886ff51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f4e029553c2dccf2d9a44d459a188c7501ef4f5d7406adb49573cac546f92fb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build

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
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

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
    assert_equal "d1asha_\td1asha_\t1.000\t147\t0\t0\t1\t147\t1\t147\t1.011E-22\t1061\n", File.read("aln")
  end
end
