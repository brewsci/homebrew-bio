class Iqtree3 < Formula
  # cite Wong_2025: "https://doi.org/10.32942/X2P62N"
  desc "Efficient and versatile phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  # Use git clone to get submodules
  url "https://github.com/iqtree/iqtree3.git", branch: "master", shallow: false
  version "3.0.1"
  license "GPL-2.0-only"
  head "https://github.com/iqtree/iqtree3.git", branch: "master", shallow: false

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "googletest" if OS.mac? # For test helpers
  depends_on "libomp" if OS.mac?
  depends_on "llvm" if OS.mac?
  depends_on "lsd2" => :optional
  fails_with gcc: "4"
  fails_with gcc: "5" do
    version "5.0"
    cause "Requires C++17 support"
  end

  def install
    # Initialize and update submodules
    system "git", "submodule", "update", "--init", "--recursive"

    # Set up environment for OpenMP
    ldflags = "-L#{Formula["libomp"].opt_lib}"
    cppflags = "-I#{Formula["libomp"].opt_include}"

    # Set environment to prevent FetchContent downloads
    ENV["FETCHCONTENT_FULLY_DISCONNECTED"] = "ON"
    ENV["FETCHCONTENT_TRY_FIND_PACKAGE_MODE"] = "ALWAYS"
    ENV.append "CFLAGS", "-I#{Formula["googletest"].opt_include}/googletest/googletest"
    args = std_cmake_args + [
      "-DCMAKE_C_COMPILER=#{ENV.cc}",
      "-DCMAKE_CXX_COMPILER=#{ENV.cxx}",
      "-DCMAKE_CXX_FLAGS=#{ldflags} #{cppflags}",
      "-DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3",
      "-DBUILD_TESTING=OFF",
      "-DIQTREE_TEST=OFF",
      "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
      "-DUSE_CMAPLE=OFF", "-DUSE_LSD2=OF",
      "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
    ]

    # Add architecture-specific optimizations
    if Hardware::CPU.intel?
      if Hardware::CPU.avx2?
        args << "-DIQTREE_FLAGS=fma"
      elsif Hardware::CPU.avx?
        args << "-DIQTREE_FLAGS=avx"
      end
    elsif Hardware::CPU.arm?
      # ARM-specific flags if needed
      args << "-DIQTREE_FLAGS=omp"
    end

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"

    # Install the binary
    bin.install "build/iqtree3"

    # Install example files and documentation if they exist
    pkgshare.install "example" if File.exist?("example")

    # Create a simple test file
    (pkgshare/"test.phy").write <<~EOS
      5 10
      Seq1  ATCGATCGAT
      Seq2  ATCGATCGAA
      Seq3  ATCGATCGTT
      Seq4  ATCGATCATT
      Seq5  ATCGATCAAA
    EOS
  end

  test do
    # Test basic functionality
    assert_match "IQ-TREE", shell_output("#{bin}/iqtree3 -h 2>&1")

    # Test with a simple phylogenetic analysis
    cp pkgshare/"test.phy", testpath
    system "bin/iqtree3", "-s", "test.phy", "-m", "GTR"

    # Check that output files were created
    assert_path_exists testpath/"test.phy.iqtree"
    assert_path_exists testpath/"test.phy.treefile"
  end
end
