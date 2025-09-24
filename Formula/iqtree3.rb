class Iqtree3 < Formula
  # cite Wong_2025: "https://doi.org/10.32942/X2P62N"
  desc "Efficient and versatile phylogenomic software by maximum likelihood"
  homepage "https://iqtree.github.io/"
  url "https://github.com/iqtree/iqtree3.git", branch: "master", shallow: false
  version "3.0.1"
  license "GPL-2.0-only"
  head "https://github.com/iqtree/iqtree3.git", branch: "master", shallow: false

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "c72eec46364d6d6c71698f015183c4b589e2b4c3297ec3be7c8be3d8eebd022e"
    sha256 cellar: :any,                 arm64_sonoma:  "5b3ce443a3fde77539e4bfdfcdbf444d4efe9343cd729b35ea9945e55c7cf9a6"
    sha256 cellar: :any,                 ventura:       "50f32eb9ab228f24447882efe371b9ffb994dca830d315b6c4ae01c2ac01d517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a339fd89e31a07f5fda9276ec449e6f3ee9fd031e48fa797d5cbb5d5ee4bd84e"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "brewsci/bio/lsd2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "googletest"
    depends_on "libomp"
    depends_on "llvm"
  end

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
      "-DZLIB_ROOT=#{Formula["zlib"].opt_prefix}",
      "-DUSE_CMAPLE=OFF",
      "-DUSE_LSD2=ON",
      "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS",
    ]

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
    system bin/"iqtree3", "-s", "test.phy", "-m", "GTR"

    # Check that output files were created
    assert_path_exists testpath/"test.phy.iqtree"
    assert_path_exists testpath/"test.phy.treefile"
  end
end
