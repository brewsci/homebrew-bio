class Openstructure < Formula
  include Language::Python::Virtualenv

  # cite Biasini_2013: "https://doi.org/10.1107/S0907444913007051"
  desc "Modular software framework for molecular modelling and visualization"
  homepage "https://openstructure.org"
  url "https://git.scicore.unibas.ch/schwede/openstructure/-/archive/2.9.3/openstructure-2.9.3.tar.gz"
  sha256 "b5958ada252a3912a71da0cefb0313a4291ac6b17c93d6e0a61d361ee62de92e"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
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
  depends_on "parasail"
  depends_on "python@3.13"
  depends_on "sqlite"
  depends_on "voronota"
  depends_on "blast" => :optional
  depends_on "dssp" => :optional
  depends_on "hh-suite" => :optional
  depends_on "mmseqs2" => :optional

  uses_from_macos "zlib"

  resource "dockq" do
    url "https://files.pythonhosted.org/packages/c1/a5/df80285b0f2e5b94562ccc1656ba8f3eaff34f7428ea04f26dad28894ae0/dockq-2.1.3.tar.gz"
    sha256 "50c4e2b4bced3bf865b12061ec0b56e23de1383dc70b445441848224f6c72c0d"
  end

  resource "components-cif" do
    url "https://files.wwpdb.org/pub/pdb/data/monomers/components.cif.gz"
    sha256 "9d7c273609b1d5d1a7247e20c882a318f5dd199860e8e7dcc1374006f51f3c0c"
  end

  patch do
    # Patch for Homebrew packaging (make boost compatibile and fix lib dir name)
    url "https://raw.githubusercontent.com/eunos-1128/openstructure/a708ecd95ca87e88b69656ce900c8320248f5183/homebrew.patch"
    sha256 "6a5f4bddcbaceaa4289e18144d08e4dff7248ec58a813369176062795e47cc0e"
  end

  def python3
    "python3.13"
  end

  def install
    if OS.mac?
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
      ENV.append "LDFLAGS", "-undefined dynamic_lookup -bundle -pthread"
    elsif OS.linux?
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{Formula["gcc"].version.major}"
      ENV.append "LDFLAGS", "-Wl,--allow-shlib-undefined -lstdc++ -pthread"
    end

    # Install python packages using virtualenv pip
    venv = virtualenv_create libexec, which(python3)
    system libexec/"bin/python", "-m", "pip", "install", "-U", *%w[
      pip
      setuptools>=61
      wheel
    ]
    system libexec/"bin/python", "-m", "pip", "install", *%w[
      biopython==1.85
      networkx==3.4.2
      numpy==2.1.0
      pandas==2.2.3
      scipy==1.15.1
      OpenMM
      parallelbar==2.5
    ]
    venv.pip_install_and_link resource("dockq")

    py_ver = Language::Python.major_minor_version python3
    py_ver_nodot = py_ver.to_s.delete(".")
    ENV.prepend_path "PATH", libexec/"bin"
    ENV.prepend_create_path "PYTHONPATH", venv.site_packages
    site_packages_path = Language::Python.site_packages python3
    (prefix/site_packages_path/"homebrew-openstructure.pth").write venv.site_packages

    lib_ext = OS.mac? ? "dylib" : "so"

    py_lib = "libpython#{py_ver}.#{lib_ext}"
    py_lib_path = if OS.mac?
      Formula["python@#{py_ver}"].opt_frameworks/"Python.framework/Versions/#{py_ver}/lib/#{py_lib}"
    elsif OS.linux?
      Formula["python@#{py_ver}"].opt_lib/py_lib
    end

    openmm_base = libexec/"lib/python#{py_ver}/site-packages/OpenMM.libs"
    include.install_symlink Dir[openmm_base/"include/**/*"]
    lib.install_symlink Dir[openmm_base/"lib/*.#{lib_ext}"]
    lib.install_symlink Dir[openmm_base/"lib/plugins/*.#{lib_ext}"]

    mkdir "build" do
      cmake_args = std_cmake_args + %W[
        -DCMAKE_CXX_COMPILER=#{ENV["CXX"]}
        -DCXX_FLAGS=#{ENV["CXXFLAGS"]}
        -DCMAKE_CXX_STANDARD=17
        -DPython_EXECUTABLE=#{libexec}/bin/python3
        -DPython_ROOT_DIR=#{libexec}
        -DPython_LIBRARY=#{py_lib_path}
        -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{py_ver_nodot}.#{lib_ext}
        -DENABLE_GUI=OFF
        -DENABLE_GFX=OFF
        -DENABLE_INFO=OFF
        -DCMAKE_VERBOSE_MAKEFILE=ON
      ]
      cmake_args << "-DZLIB_ROOT=#{Formula["zlib"].opt_prefix}" if OS.linux?

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
        -DPython_EXECUTABLE=#{libexec}/bin/python3
        -DPython_ROOT_DIR=#{libexec}
        -DPython_LIBRARY=#{py_lib_path}
        -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{py_ver_nodot}.#{lib_ext}
        -DCOMPOUND_LIB=#{buildpath}/build/compounds.chemlib
        -DPARASAIL_INCLUDE_DIR=#{Formula["parasail"].opt_include}
        -DPARASAIL_LIBRARY=#{Formula["parasail"].opt_lib}/libparasail.#{lib_ext}
        -DOPEN_MM_LIBRARY=#{lib}/libOpenMM.#{lib_ext}
        -DOPEN_MM_INCLUDE_DIR=#{include}
        -DOPEN_MM_PLUGIN_DIR=#{lib}
        -DENABLE_MM=ON
        -DUSE_RPATH=ON
        -DOPTIMIZE=ON
        -DENABLE_PARASAIL=ON
        -DCOMPILE_TMTOOLS=ON
        -DENABLE_GFX=ON
        -DENABLE_GUI=OFF
        -DENABLE_INFO=OFF
        -DUSE_SHADER=ON
        -DUSE_DOUBLE_PRECISION=OFF
        -DCMAKE_VERBOSE_MAKEFILE=ON
      ]
      cmake_args << "-DZLIB_ROOT=#{Formula["zlib"].opt_prefix}" if OS.linux?

      system "cmake", "..", *cmake_args
      system "make", "VERBOSE=1"
      system "make", "install"
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/ost -h 2>&1", 255)
  end
end
