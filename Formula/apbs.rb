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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "8408ebfce6311dbc40f58a5ebd02c7aa200442504cf9015c51eecf8c3ab4bd3f"
    sha256 cellar: :any,                 arm64_sonoma:  "3f097a8d2074385b336889d0b3ee819cd70082e0f9b0cd67eee21241561f82f3"
    sha256 cellar: :any,                 ventura:       "7b9256ef575f32030eeb9cda3406b24547b9bac57036382189ab5fbb481f4d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db17dcffcce57503753848946b357ad4cf60fef9179de5b32b1e904c0e74e17"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas"
  depends_on "python@3.13"
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
      -DPYTHON_VERSION=3.13
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
