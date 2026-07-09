class Voronota < Formula
  # cite Olechnovič_2014: "https://doi.org/10.1002/jcc.23538"
  desc "Compute Voronoi diagram vertices for macromolecular structures"
  homepage "https://github.com/kliment-olechnovic/voronota"
  url "https://github.com/kliment-olechnovic/voronota/archive/refs/tags/v1.29.4781.tar.gz"
  sha256 "efd46fa08437c818f45bada7be11b539e10822923bcf03ad93d25a02660fb634"
  license "MIT"
  head "https://github.com/kliment-olechnovic/voronota.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "674b9f7c5b7d4f9789ef7969f0d55c55da04456698109e77a5d99c0cabb20572"
    sha256 cellar: :any, arm64_sequoia: "a07602c737fbf5a8e2d727bc210282998526345cadfedcd66853c948b2f5ab19"
    sha256 cellar: :any, arm64_sonoma:  "d9d6f8b90fe6bfdcb556cfc6824dcbd1c451eada65fcd9dae4b517f2f1bec0b5"
    sha256 cellar: :any, x86_64_linux:  "1f1d4f49c29f423a9b2b93d830038c3253fadcaa0367f65c6696a9bd382b611a"
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
        "-I#{formula_opt_include("libomp")} -Xpreprocessor -fopenmp"
      ENV.append "LDFLAGS",
        "-L#{formula_opt_lib("libomp")} -lomp"
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
