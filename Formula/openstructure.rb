class Openstructure < Formula
  desc "Modular software framework for molecular modelling and visualization"
  homepage "https://openstructure.org"
  url "https://git.scicore.unibas.ch/schwede/openstructure/-/archive/2.9.3/openstructure-2.9.3.tar.gz"
  sha256 "b5958ada252a3912a71da0cefb0313a4291ac6b17c93d6e0a61d361ee62de92e"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "clustal-w"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "llvm" if OS.mac?
  depends_on "opencl-headers"
  depends_on "opencl-icd-loader"
  depends_on "parasail"
  depends_on "pocl"
  depends_on "pyqt@5"
  depends_on "python@3.13"
  depends_on "qt@5"
  depends_on "sip"
  depends_on "sqlite3"
  depends_on "voronota"
  depends_on "zlib"

  resource "components-cif" do
    url "https://files.wwpdb.org/pub/pdb/data/monomers/components.cif.gz"
    sha256 "9d7c273609b1d5d1a7247e20c882a318f5dd199860e8e7dcc1374006f51f3c0c"
  end

  patch do
    # Patch for Homebrew packaging(boost compatibility and file locations)
    url "https://raw.githubusercontent.com/eunos-1128/openstructure/2f7c0806c77d5149adadc36a6bc6f467e2793837/homebrew.patch"
    sha256 "8ae8d57e204272451dbdf4fa8a9d4035dea0bbd5a3f4b4dd8636e26340cce90f"
  end

  def python3
    "python3.13"
  end

  def install
    # ENV.cxx11

    if OS.linux?
      gcc = Formula["gcc"]
      ENV["CXX"] = gcc.opt_bin/"g++-#{gcc.version.major}"
    else
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
    end

    xy = Language::Python.major_minor_version python3
    xy_nodot = xy.to_s.delete(".")
    ENV.prepend_path "PATH", "#{HOMEBREW_PREFIX}/bin/python#{xy}"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system python3, "-m", "pip", "install", "--prefix=#{libexec}",
      "numpy", "pandas", "scipy", "networkx"
    system python3 "-m", "pip", "install", "--only-binary", ":all:", "OpenMM"

    lib_ext = OS.mac? ? "dylib" : "so"

    openmm_base = libexec/"lib/python#{xy}/site-packages/OpenMM.libs"
    lib.install openmm_base/"lib/libOpenMM.#{lib_ext}"
    lib.install Dir[openmm_base/"lib/libOpenMM*.#{lib_ext}"]
    lib.install Dir[openmm_base/"lib/plugins/*.{#{lib_ext}}"]

    rpaths = [
      lib,
      openmm_base/"lib/",
      openmm_base/"lib/plugins/",
    ].join(";")

    # Set RPATH to `#{prefix}/lib` and OpenMM libs
    inreplace buildpath/"CMakeLists.txt",
      'CMAKE_INSTALL_RPATH "$ORIGIN/../${LIB_DIR}"',
      "CMAKE_INSTALL_RPATH #{rpaths}"

    mkdir "build" do
      args = std_cmake_args + %W[
        -DCMAKE_CXX_COMPILER=#{ENV["CXX"]}
        -DCMAKE_CXX_STANDARD=17
        -DPython_EXECUTABLE=#{Formula["python@#{xy}"].opt_prefix}/bin/python#{xy}
        -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{xy_nodot}.#{lib_ext}
        -DOPEN_MM_LIBRARY=#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/lib/libOpenMM.#{lib_ext}
        -DOPEN_MM_INCLUDE_DIR=#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/include
        -DOPEN_MM_PLUGIN_DIR=#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/lib/plugins
        -DUSE_RPATH=1
        -DCMAKE_VERBOSE_MAKEFILE=1
      ]

      system "cmake", "..", *args
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
      args = std_cmake_args + %W[
        -DCMAKE_CXX_COMPILER=#{ENV["CXX"]}
        -DCMAKE_CXX_STANDARD=17
        -DPREFIX=#{prefix}
        -DPython_EXECUTABLE=#{Formula["python@#{xy}"].opt_prefix}/bin/python#{xy}
        -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{xy_nodot}.#{lib_ext}
        -DOPEN_MM_LIBRARY=#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/lib/libOpenMM.#{lib_ext}
        -DOPEN_MM_INCLUDE_DIR=#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/include
        -DOPEN_MM_PLUGIN_DIR=#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/lib/plugins
        -DCOMPOUND_LIB=#{buildpath}/build/compounds.chemlib
        -DUSE_RPATH=1
        -DENABLE_MM=1
        -DOPTIMIZE=1
        -DENABLE_PARASAIL=1
        -DCOMPILE_TMTOOLS=1
        -DENABLE_GFX=1
        -DENABLE_GUI=0
        -DENABLE_INFO=1
        -DCMAKE_VERBOSE_MAKEFILE=1
      ]

      system "cmake", "..", *args
      system "make", "VERBOSE=1"
      system "make", "check"
      system "make", "install"
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/ost -h 2>&1", 255)
  end
end
