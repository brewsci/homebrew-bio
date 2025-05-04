class Voronota < Formula
  desc "Compute Voronoi diagram vertices for macromolecular structures"
  homepage "https://github.com/kliment-olechnovic/voronota"
  url "https://github.com/kliment-olechnovic/voronota/archive/refs/tags/v1.29.4370.tar.gz"
  sha256 "c7b55f1de0a36502121d87d5fe980dbc13223e0323c86a644cf1f3b39de52eda"
  license "MIT"
  head "https://github.com/kliment-olechnovic/voronota.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "boost"
  depends_on "glew"
  depends_on "glfw"
  depends_on "python3"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "gcc"
    depends_on "mesa"
  end

  def install
    ENV.cxx11
    
    if OS.mac?
      ENV.append "CXXFLAGS", 
        "-Xpreprocessor -fopenmp -I#{libomp.opt_include} -L#{libomp.opt_lib} -lomp"
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
    # puts args
    # exit

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Commands:", shell_output("#{bin}/voronota --help 2>&1", 1)
  end
end
