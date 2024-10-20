class HhSuite < Formula
  # cite Steinegger_2019: "https://doi.org/10.1186/s12859-019-3019-7"
  desc "Remote protein homology detection suite"
  homepage "https://github.com/soedinglab/hh-suite"
  url "https://github.com/soedinglab/hh-suite/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "dd67f7f3bf601e48c9c0bc4cf1fbe3b946f787a808bde765e9436a48d27b0964"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/soedinglab/hh-suite.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5105b1d2ae59850785df08947a53d046386b547ba059210216f4b1b810db4ca6"
    sha256 cellar: :any,                 arm64_sonoma:  "008fc503311e698ab01bada3c3860df3580aee62f6c842b1af46c476874e78ca"
    sha256 cellar: :any,                 ventura:       "89317d52604182d57bbfc52e121e10ae7d339624da98dc0f6fbaf153bb1e7f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "574fe5c131734b50bb2298319935362e6c2dfba1e04fba728e23a09d0ac8fc7f"
  end
  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "open-mpi"

  uses_from_macos "perl"

  def install
    args = *std_cmake_args << "-DCHECK_MPI=1"
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
