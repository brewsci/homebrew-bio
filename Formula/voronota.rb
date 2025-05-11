class Voronota < Formula
  # cite Olechnovič_2014: "https://doi.org/10.1002/jcc.23538"
  desc "Compute Voronoi diagram vertices for macromolecular structures"
  homepage "https://github.com/kliment-olechnovic/voronota"
  url "https://github.com/kliment-olechnovic/voronota/archive/refs/tags/v1.29.4370.tar.gz"
  sha256 "c7b55f1de0a36502121d87d5fe980dbc13223e0323c86a644cf1f3b39de52eda"
  license "MIT"
  head "https://github.com/kliment-olechnovic/voronota.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "3ebef923cb7653925ab9c20ec044b29b62a48805c08144ffb920db68f1b10d49"
    sha256 cellar: :any,                 arm64_sonoma:  "47b50a97c621211052518ceeece0fc000522502e9e3ec47a34734f43e5c4edb7"
    sha256 cellar: :any,                 ventura:       "0f3d9661ea66d40ba767afb6313c8eb8e8cdc539a00af39f69c4e9db2b2e4a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f6d066ec58f3408d6b454adaa8bab91f090e4386ab1d7876a5c0d250029db8b"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "glew"
  depends_on "glfw"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "gcc" # for OpenMP support
    depends_on "mesa"
  end

  def install
    ENV.cxx11

    if OS.mac?
      ENV.append "CXXFLAGS",
        "-I#{Formula["libomp"].opt_include} -Xpreprocessor -fopenmp"
      ENV.append "LDFLAGS",
        "-L#{Formula["libomp"].opt_lib} -lomp"
    elsif OS.linux?
      ENV.append "CXXFLAGS", "-fopenmp"
    end

    args = std_cmake_args + %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DCMAKE_CXX_COMPILER=#{ENV["CXX"]}
      -DCMAKE_CXX_FLAGS=#{ENV["CXXFLAGS"]}
      -DEXPANSION_JS=ON
      -DEXPANSION_LT=ON
      -DEXPANSION_GL=ON
    ]

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Commands:", shell_output("#{bin}/voronota --help 2>&1", 1)
  end
end
