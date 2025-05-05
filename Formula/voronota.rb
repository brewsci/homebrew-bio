class Voronota < Formula
  desc "Compute Voronoi diagram vertices for macromolecular structures"
  homepage "https://github.com/kliment-olechnovic/voronota"
  url "https://github.com/kliment-olechnovic/voronota/archive/refs/tags/v1.29.4370.tar.gz"
  sha256 "c7b55f1de0a36502121d87d5fe980dbc13223e0323c86a644cf1f3b39de52eda"
  license "MIT"
  head "https://github.com/kliment-olechnovic/voronota.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "7cdfcb2b230f2e2d1f1272a4fdbeea76cf3ccf1a3b576768a4bb94e32965150b"
    sha256 cellar: :any,                 arm64_sonoma:  "140577de563b4926ed57a1f72431a4d833b4d9f89829a777ea6cc6c9b380ac86"
    sha256 cellar: :any,                 ventura:       "8ad8d586af052a9c7d6df66f384e21160d14eb16ac19eb090b07e550284eaa15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f0c641177df3f582f3d779b17672e77fd16a2f79574fabec35ee35cc6726973"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "boost"
  depends_on "glew"
  depends_on "glfw"
  depends_on "python"

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
