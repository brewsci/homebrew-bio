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
    sha256 cellar: :any,                 arm64_tahoe:   "f6d69941551efc750bb1c7b36562bbd9cd5eaafc821104cb6b6139bfb3351664"
    sha256 cellar: :any,                 arm64_sequoia: "79c700be345c86e086ea7fcbc0ffbbc7457384cbabc7cbd78f96a0838d171a66"
    sha256 cellar: :any,                 arm64_sonoma:  "14ac8bea4ee533b45f310ff1ace169ef554a699d77b7b88013d9a6adfd701613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "956b8e4472b1ba72c2e5090e7799a513b8eb03a8f208a04776ebde712d2f2432"
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
