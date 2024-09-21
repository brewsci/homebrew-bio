class Libcuemol2 < Formula
  desc "Library of CueMol2: Molecular Visualization Framework"
  homepage "https://github.com/CueMol/cuemol2"
  url "https://github.com/CueMol/cuemol2.git",
  revision: "7c7065e7274d9d8f968d690d259b1d431193ae1e"
  version "2024.09.21"
  license :cannot_represent
  head "https://github.com/CueMol/cuemol2.git", branch: "develop"

  depends_on "bison" => :build # needs bison >= 3.7.4
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "little-cms2"
  depends_on "xz"

  uses_from_macos "expat"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  resource "cgal4" do
    url "https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.14.3/CGAL-4.14.3.tar.xz"
    sha256 "5bafe7abe8435beca17a1082062d363368ec1e3f0d6581bb0da8b010fb389fe4"
  end

  def install
    # install CGAL@4 first
    resource("cgal4").stage do
      args = %W[
        -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
        -DWITH_CGAL_Qt5=OFF
        -DWITH_CGAL_ImageIO=OFF
        -DCGAL_DISABLE_GMP=TRUE
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DBUILD_SHARED_LIBS=FALSE
        -DCMAKE_CXX_STANDARD=14
        -DCMAKE_CXX_STANDARD_REQUIRED=ON
        -DCMAKE_CXX_EXTENSIONS=OFF
      ]
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: prefix/"cgal4"), *args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
    cflags = ["-I#{prefix}/cgal4/include"]
    args = %W[
      -DBoost_ROOT=#{Formula["boost"].opt_prefix}
      -DFFTW_ROOT=#{Formula["fftw"].opt_prefix}
      -DLCMS2_ROOT=#{Formula["little-cms2"].opt_prefix}
      -DGLEW_ROOT=#{Formula["glew"].opt_prefix}
      -DBUILD_PYTHON_BINDINGS=ON
      -DPython3_ROOT_DIR=#{Formula["python@3.12"].opt_prefix}
      -DBUILD_XPCJS_BINDINGS=ON
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_PREFIX_PATH=#{prefix}/cgal4
      -DCMAKE_C_FLAGS=#{cflags.join(" ")}
      -DCMAKE_EXE_LINKER_FLAGS=-L#{prefix}/cgal4/lib
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Usage: blendpng", shell_output("#{bin}/blendpng --help")
  end
end
