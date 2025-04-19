class Voronota < Formula
  desc "Compute Voronoi diagram vertices for macromolecular structures"
  homepage "https://github.com/kliment-olechnovic/voronota"
  url "https://github.com/kliment-olechnovic/voronota/archive/refs/tags/v1.29.4370.tar.gz"
  sha256 "c7b55f1de0a36502121d87d5fe980dbc13223e0323c86a644cf1f3b39de52eda"
  license "MIT"
  head "https://github.com/kliment-olechnovic/voronota.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "open-mpi" => :optional
  depends_on "libomp" if OS.mac?

  def install
    args = std_cmake_args + [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
      "-DCMAKE_BUILD_TYPE=Release",
      "-DEXPANSION_JS=ON",
      "-DEXPANSION_LT=ON",
      "-DEXPANSION_GL=ON",
    ]

    if build.with?("openmp")
      if OS.mac?
        # use Apple Clang + libomp
        ENV["CXX"] = "clang++"
        args << "-DCMAKE_CXX_FLAGS=-Xpreprocessor -fopenmp"
        args << "-DCMAKE_EXE_LINKER_FLAGS=-lomp"
      else
        # Homebrew GCC provides OpenMP on Linux
        ENV["CXX"] = Formula["gcc"].opt_bin/"g++"
        args << "-DCMAKE_CXX_FLAGS=-fopenmp"
      end
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
    assert_match "Commands:", shell_output("#{bin}/voronota --help 2>&1", 1)
  end
end
