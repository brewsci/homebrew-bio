class Openstructure < Formula
  desc "Modular software framework for molecular modelling and visualization"
  homepage "https://openstructure.org"
  url "https://git.scicore.unibas.ch/schwede/openstructure/-/archive/2.9.3/openstructure-2.9.3.tar.gz"
  sha256 "b5958ada252a3912a71da0cefb0313a4291ac6b17c93d6e0a61d361ee62de92e"
  license "LGPL-3.0-or-later"
  head "https://git.scicore.unibas.ch/schwede/openstructure.git", branch: "develop"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "clustal-w"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc"
  depends_on "glew"
  depends_on "glfw"
  depends_on "glm"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "llvm" if OS.mac?
  depends_on "ocl-icd"
  depends_on "opencl-headers"
  depends_on "parasail"
  depends_on "pyqt@5"
  depends_on "python@3.13"
  depends_on "qt@5"
  depends_on "sip"
  depends_on "sqlite3"
  depends_on "voronota"
  depends_on "blast" => :optional
  depends_on "dssp" => :optional
  depends_on "hh-suite" => :optional
  depends_on "mmseqs2" => :optional

  uses_from_macos "zlib"

  resource "components-cif" do
    url "https://files.wwpdb.org/pub/pdb/data/monomers/components.cif.gz"
    sha256 "9d7c273609b1d5d1a7247e20c882a318f5dd199860e8e7dcc1374006f51f3c0c"
  end

  patch do
    # Patch for Homebrew packaging (boost compatibility and file locations)
    url "https://raw.githubusercontent.com/eunos-1128/openstructure/2f7c0806c77d5149adadc36a6bc6f467e2793837/homebrew.patch"
    sha256 "8ae8d57e204272451dbdf4fa8a9d4035dea0bbd5a3f4b4dd8636e26340cce90f"
  end

  def python3
    "python3.13"
  end

  def install
    if OS.mac?
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
      ENV.append "LDFLAGS", "-undefined dynamic_lookup -pthread"
    elsif OS.linux?
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{Formula["gcc"].version.major}"
      ENV.append "LDFLAGS", "-Wl,--allow-shlib-undefined -lstdc++ -pthread"
    end

    ENV.prepend_path "PATH", libexec/"bin"
    py_ver = Language::Python.major_minor_version python3
    py_ver_nodot = py_ver.to_s.delete(".")
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{py_ver}/site-packages"
    system python3, "-m", "pip", "install", "--prefix=#{libexec}",
      "numpy", "pandas", "scipy", "networkx", "DockQ"

    lib_ext = OS.mac? ? "dylib" : "so"

    py_lib = "libpython#{py_ver}.#{lib_ext}"
    if OS.mac?
      py_lib_path = Formula["python@#{py_ver}"].opt_frameworks/"Python.framework/Versions/#{py_ver}/lib/#{py_lib}"
    elsif OS.linux?
      py_lib_path = Formula["python@#{py_ver}"].opt_lib/"libpython#{py_ver}.#{lib_ext}"
    end

    mkdir "build" do
      cmake_args = std_cmake_args + %W[
        -DCMAKE_CXX_COMPILER=#{ENV["CXX"]}
        -DCXX_FLAGS=#{ENV["CXXFLAGS"]}
        -DCMAKE_CXX_STANDARD=17
        -DPython_EXECUTABLE=#{Formula["python@#{py_ver}"].opt_prefix}/bin/python#{py_ver}
        -DPython_ROOT_DIR=#{Formula["python@#{py_ver}"].opt_prefix}
        -DPython_LIBRARY=#{py_lib_path}
        -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{py_ver_nodot}.#{lib_ext}
        -DENABLE_GUI=OFF
        -DENABLE_GFX=OFF
        -DENABLE_INFO=OFF
        -DCMAKE_VERBOSE_MAKEFILE=ON
      ]

      system "cmake", "..", *cmake_args
      system "make", "VERBOSE=1"

      resource("components-cif").fetch
      components_cif_path = resource("components-cif").cached_download
      cp components_cif_path, "components.cif.gz"

      system "stage/bin/chemdict_tool", "create",
              "components.cif.gz", "compounds.chemlib",
              "pdb", "-i"
      system "stage/bin/chemdict_tool", "update",
              buildpath/"modules/conop/data/charmm.cif",
              "compounds.chemlib", "charmm"

      # Re-configure with compound library
      cmake_args = std_cmake_args + %W[
        -DCMAKE_CXX_COMPILER=#{ENV["CXX"]}
        -DCXX_FLAGS=#{ENV["CXXFLAGS"]}
        -DCMAKE_CXX_STANDARD=17
        -DPREFIX=#{prefix}
        -DPython_EXECUTABLE=#{Formula["python@#{py_ver}"].opt_prefix}/bin/python#{py_ver}
        -DPython_ROOT_DIR=#{Formula["python@#{py_ver}"].opt_prefix}
        -DPython_LIBRARY=#{py_lib_path}
        -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{py_ver_nodot}.#{lib_ext}
        -DCOMPOUND_LIB=#{buildpath}/build/compounds.chemlib
        -DPARASAIL_INCLUDE_DIR=#{Formula["parasail"].opt_include}
        -DPARASAIL_LIBRARY=#{Formula["parasail"].opt_lib}/libparasail.#{lib_ext}
        -DUSE_RPATH=ON
        -DOPTIMIZE=ON
        -DENABLE_PARASAIL=ON
        -DCOMPILE_TMTOOLS=ON
        -DENABLE_GFX=ON
        -DENABLE_GUI=ON
        -DENABLE_INFO=ON
        -DUSE_SHADER=ON
        -DUSE_DOUBLE_PRECISION=OFF
        -DCMAKE_VERBOSE_MAKEFILE=ON
      ]

      system "cmake", "..", *cmake_args
      system "make", "VERBOSE=1"
      system "make", "check"
      system "make", "install"
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/ost -h 2>&1", 255)
  end
end
