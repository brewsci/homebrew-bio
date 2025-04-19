class Voronota < Formula
  desc "Compute Voronoi diagram vertices for macromolecular structures"
  homepage "https://github.com/kliment-olechnovic/voronota"
  url "https://github.com/kliment-olechnovic/voronota/archive/refs/tags/v1.29.4370.tar.gz"
  sha256 "c7b55f1de0a36502121d87d5fe980dbc13223e0323c86a644cf1f3b39de52eda"
  license "MIT"
  head "https://github.com/kliment-olechnovic/voronota.git", branch: "master"

  option "with-js", "Enable Voronota-JS expansion"
  option "with-lt", "Enable Voronota-LT expansion"
  option "with-gl", "Enable Voronota-GL expansion"
  option "with-openmp", "Compile with OpenMP support"
  option "with-mpi", "Compile with MPI support"

  depends_on "cmake" => :build
  depends_on "gcc" => :optional
  depends_on "open-mpi" => :optional

  def install
    args = std_cmake_args + [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
      "-DCMAKE_BUILD_TYPE=Release",
      "-DEXPANSION_JS=#{build.with?("js")  ? "ON" : "OFF"}",
      "-DEXPANSION_LT=#{build.with?("lt")  ? "ON" : "OFF"}",
      "-DEXPANSION_GL=#{build.with?("gl")  ? "ON" : "OFF"}",
      "-DUSE_TR1=#{build.with?("tr1")      ? "1"  : "0"}",
    ]

    if build.with?("openmp")
      # Homebrew GCC provides OpenMP
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++"
      args << "-DCMAKE_CXX_FLAGS=-fopenmp"
    end

    if build.with?("mpi")
      ENV["MPICXX"] = "#{Formula["open-mpi"].opt_bin}/mpic++"
      args << "-DENABLE_MPI=ON"
    end

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Commands:", shell_output("#{bin}/voronota --help --help 2>&1")
  end
end
