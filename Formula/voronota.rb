class Voronota < Formula
  # cite Olechnovič_2014: "https://doi.org/10.1002/jcc.23538"
  desc "Compute Voronoi diagram vertices for macromolecular structures"
  homepage "https://github.com/kliment-olechnovic/voronota"
  url "https://github.com/kliment-olechnovic/voronota/archive/refs/tags/v1.29.4415.tar.gz"
  sha256 "ac3ab668bb808343fd2d5bd5eef621cc4aede5f1e4423d5e752005caa7b889b2"
  license "MIT"
  head "https://github.com/kliment-olechnovic/voronota.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia: "852cd983c11446640e3c0f677658c03a3b7213745bd630319087639c9064d599"
    sha256 cellar: :any,                 arm64_sonoma:  "b62d2853de710428b1d8607762a10a8601796be64afb9b681973b3b1320b81ce"
    sha256 cellar: :any,                 ventura:       "65a083256258dcab0d09e7c34333590935deee106f366690dc875bc2137ccb31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aab9f9c4e5802783bd9bc1270a518e71fe5759fe1f1ca72b195e049c31b877d"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "glew"
  depends_on "glfw"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
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

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Commands:", shell_output("#{bin}/voronota --help 2>&1", 1)
  end
end
