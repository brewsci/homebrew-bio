class Apbs < Formula
  desc "Adaptive Poisson-Boltzmann Solver"
  homepage "https://www.poissonboltzmann.org/"
  # pull from git tag to get submodules
  url "https://github.com/Electrostatics/apbs.git",
    tag:      "v3.4.1",
    revision: "f24dd7629a41e253287bbb643589cd2afb776484"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  revision 2
  head "https://github.com/Electrostatics/apbs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "099bf06c1c2f52bde9ff12cffefa8cab18fa4eeb6c2e822f3954290e0216d968"
    sha256 cellar: :any,                 ventura:      "9b612610d1915c82cedb0dca50dcd186739dba51706d42900661a6e366e33138"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3d2358e55b7cea604916ecddc2e84550e2f6a3f4020d5c5045b0894537139ca4"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas"
  depends_on "python@3.12"
  depends_on "suite-sparse"
  depends_on "superlu"

  on_macos do
    depends_on "gettext"
    depends_on "libiconv"
  end

  resource "fetk" do
    url "https://github.com/Electrostatics/FETK/archive/refs/tags/1.9.3.tar.gz"
    sha256 "2ce7ab04cba4403f4208c3ecf1c81a0a18aae6a77d22da0ffa5f64c2da7c6f28"
  end

  def install
    # install FETK first
    resource("fetk").stage do
      args = %w[
        -DBLA_STATIC=OFF
        -DBUILD_SUPERLU=OFF
      ]
      args << "-DCMAKE_C_FLAGS=-Wno-error=implicit-int" if OS.mac?
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: prefix/"fetk"), *args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # fix FETK path
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "include(ImportFETK)", ""
      s.gsub! "import_fetk(${FETK_VERSION})", ""
    end
    inreplace "tools/manip/inputgen.py", '"rU"', '"r"'

    # include FETK installed in the prefix directory
    fetk_cmake_prefix = prefix/"fetk/share/fetk/cmake"
    cflags = ["-I#{prefix}/fetk/include"]
    cflags << "-Wno-error=incompatible-pointer-types" if OS.mac?
    # failed if additional modules and python are enabled
    args = std_cmake_args + %W[
      -DHOMEBREW_ALLOW_FETCHCONTENT=OFF
      -DBUILD_TOOLS=ON
      -DENABLE_GEOFLOW=OFF
      -DENABLE_BEM=OFF
      -DAPBS_STATIC_BUILD=ON
      -DENABLE_OPENMP=OFF
      -DAPBS_LIBS=mc;maloc
      -DENABLE_PYTHON=OFF
      -DPYTHON_VERSION=3.12
      -DCMAKE_MODULE_PATH=#{fetk_cmake_prefix}
      -DCMAKE_C_FLAGS=#{cflags.join(" ")}
      -DCMAKE_EXE_LINKER_FLAGS=-L#{prefix}/fetk/lib
    ]
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Some useful tools have been also installed in #{prefix}/share/apbs/tools.
      You may want to add the following to your .bashrc or .zshrc to use these tools:
        export APBS_TOOLS_HOME=#{prefix}/share/apbs/tools/
        export PATH=${PATH}:${APBS_TOOLS_HOME}/bin
    EOS
  end

  test do
    cd prefix/"share/apbs/examples/solv" do
      system bin/"apbs", "apbs-mol.in"
    end
  end
end
