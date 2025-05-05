class Voronota < Formula
  desc "Compute Voronoi diagram vertices for macromolecular structures"
  homepage "https://github.com/kliment-olechnovic/voronota"
  url "https://github.com/kliment-olechnovic/voronota/archive/refs/tags/v1.29.4370.tar.gz"
  sha256 "c7b55f1de0a36502121d87d5fe980dbc13223e0323c86a644cf1f3b39de52eda"
  license "MIT"
  head "https://github.com/kliment-olechnovic/voronota.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5478c60efa8e02957fbe8fb28b1b0080cc5bca3682534c01733a4614a679390f"
    sha256 cellar: :any,                 arm64_sonoma:  "635b77fae3b4820788a11898bfa9fcbff6a588dcf7977d065778c0829c0f4ecc"
    sha256 cellar: :any,                 ventura:       "17e8050129c94a6e5c0ba57a3d732f2286e6314b62f3d77d88772eb18d7a1c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7236d50cb848d3babd0976894bfbc9cae7ded5bf51c29b544ddbb62df537444b"
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
