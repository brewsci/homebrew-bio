class HhSuite < Formula
  # cite Steinegger_2019: "https://doi.org/10.1186/s12859-019-3019-7"
  desc "Remote protein homology detection suite"
  homepage "https://github.com/soedinglab/hh-suite"
  url "https://github.com/soedinglab/hh-suite/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "dd67f7f3bf601e48c9c0bc4cf1fbe3b946f787a808bde765e9436a48d27b0964"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/soedinglab/hh-suite.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_tahoe:   "3e09eb1a51afe2768103bb23034517fd69b1b64e39cd3dddb42e88c6d64f3f91"
    sha256 cellar: :any,                 arm64_sequoia: "67926e0b17f68998beb68c3cc327431a8cd61b2635651a1114590480cebb26cd"
    sha256 cellar: :any,                 arm64_sonoma:  "9a586865e33158ab6ec86916a577abc3a4dbafbeb6e73f6e270581b84675b232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "980a182e49b239fe39c8b20423a82fc898c61ad53ce2d3895869f631d3d95d6c"
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "open-mpi"

  uses_from_macos "perl"

  def install
    args = *std_cmake_args << "-DCHECK_MPI=1"
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    args << if Hardware::CPU.arm?
      "-DHAVE_ARM8=1"
    else
      "-DHAVE_SSE4_1=1"
    end

    if OS.mac?
      libomp = Formula["libomp"]
      args << "-DOpenMP_C_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
    end

    # Fix an error: no member named 'ptr_fun' in namespace 'std'
    inreplace "src/a3m_compress.cpp", "std::not1(std::ptr_fun<int, int>(std::isspace)))",
                                      "[](unsigned char ch) { return !std::isspace(ch); })"
    system "cmake", ".", *args
    system "make", "install"
    prefix.install "scripts"
    bin.install_symlink prefix/"scripts/reformat.pl"
    pkgshare.install ["data/query.a3m", "data/test.sh"]
  end

  def caveats
    "HH-suite requires at least SSE4.1 CPU instruction support." if !Hardware::CPU.sse4? && !Hardware::CPU.arm?
  end

  test do
    cp pkgshare/"query.a3m", testpath
    cp pkgshare/"test.sh", testpath
    ENV["OMPI_ALLOW_RUN_AS_ROOT"] = "1"
    ENV["OMPI_ALLOW_RUN_AS_ROOT_CONFIRM"] = "1"
    system "./test.sh"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
