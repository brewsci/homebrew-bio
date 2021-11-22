class HhSuite < Formula
  # cite Steinegger_2019: "https://doi.org/10.1186/s12859-019-3019-7"
  desc "Remote protein homology detection suite"
  homepage "https://github.com/soedinglab/hh-suite"
  url "https://github.com/soedinglab/hh-suite/archive/v3.3.0.tar.gz"
  sha256 "dd67f7f3bf601e48c9c0bc4cf1fbe3b946f787a808bde765e9436a48d27b0964"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/soedinglab/hh-suite.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "7f80ecc9a25f0db8279b837dd0bc07061d6da2c2991cb50aba56e887670d887c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "72ff32d4d23b5f7861984cae8ce1a24059b27ca1fd4a0a8a526edbbf27502332"
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
      args << "-DOpenMP_C_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
    end

    system "cmake", ".", *args
    system "make", "install"
    cp "scripts/reformat.pl", bin
    rm_rf "scripts"
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
