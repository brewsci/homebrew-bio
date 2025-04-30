class Openstructure < Formula
  include Language::Python::Virtualenv

  # cite Biasini_2013: "https://doi.org/10.1107/S0907444913007051"
  desc "Modular software framework for molecular modelling and visualization"
  homepage "https://openstructure.org"
  url "https://git.scicore.unibas.ch/schwede/openstructure/-/archive/2.9.3/openstructure-2.9.3.tar.gz"
  sha256 "b5958ada252a3912a71da0cefb0313a4291ac6b17c93d6e0a61d361ee62de92e"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build if OS.linux?
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/clustal-w"
  depends_on "brewsci/bio/parasail"
  depends_on "brewsci/bio/sip@4"
  depends_on "brewsci/bio/usalign"
  depends_on "brewsci/bio/voronota"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc"
  depends_on "glew"
  depends_on "glfw"
  depends_on "glm"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "llvm" if OS.mac?
  depends_on "opencl-icd-loader" if OS.linux?
  depends_on "postgresql@15" if OS.mac?
  depends_on "python@3.13"
  depends_on "qt@5"
  depends_on "sqlite"

  uses_from_macos "zlib"

  resource "components-cif" do
    url "https://files.wwpdb.org/pub/pdb/data/monomers/components.cif.gz"
    sha256 "71ec068480215d86c561ee9216c21dfa1108d76eb38a3c54ddc27d28ef9c0b29"
  end

  resource "dockq" do
    url "https://files.pythonhosted.org/packages/c1/a5/df80285b0f2e5b94562ccc1656ba8f3eaff34f7428ea04f26dad28894ae0/dockq-2.1.3.tar.gz"
    sha256 "50c4e2b4bced3bf865b12061ec0b56e23de1383dc70b445441848224f6c72c0d"
  end

  patch do
    # Patch for Homebrew packaging (make openstructure src compatibile with boost@1.88 and fix CMake configs)
    url "https://raw.githubusercontent.com/eunos-1128/openstructure/05f1081c35408651ad72b7fdcbf6e5a44de5672e/homebrew.patch"
    sha256 "8771bea089366502384f3d71bb060c1e4547ee2b9f454ba48ffef3ad56da748b"
  end

  def python3
    "python3.13"
  end

  def install
    if OS.mac?
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
      ENV.append "LDFLAGS", "-undefined dynamic_lookup"
    elsif OS.linux?
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{Formula["gcc"].version.major}"
      ENV.append "LDFLAGS", "-Wl,--allow-shlib-undefined -lstdc++ -L#{Formula["zlib"].opt_lib}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["zlib"].opt_include}"
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["zlib"].opt_lib}/pkgconfig"
    end

    # Install python packages using virtualenv pip
    venv = virtualenv_create libexec, which(python3)
    system libexec/"bin/python", "-m", "pip", "install", "-U", *%w[
      pip
      setuptools
      setuptools-scm
      wheel
    ]
    system libexec/"bin/python", "-m", "pip", "install", *%w[
      biopython
      networkx<3.0
      numpy<2.0
      pandas<2.3
      scipy<2.0
      OpenMM
      parallelbar
      PyQt5
    ]
    venv.pip_install_and_link resource("dockq")

    py_ver = Language::Python.major_minor_version python3
    py_ver_nodot = py_ver.to_s.delete(".")
    ENV.prepend_path "PATH", libexec/"bin"
    ENV.prepend_create_path "PYTHONPATH", venv.site_packages
    site_packages_path = Language::Python.site_packages python3
    (prefix/site_packages_path/"homebrew-openstructure.pth").write venv.site_packages

    lib_ext = OS.mac? ? "dylib" : "so"

    openmm_libs_base = libexec/"lib/python#{py_ver}/site-packages/OpenMM.libs"

    rpaths = [
      lib,
      openmm_libs_base/"lib",
      openmm_libs_base/"lib/plugins",
    ]

    inreplace "CMakeLists.txt",
      'CMAKE_INSTALL_RPATH "$ORIGIN/../${LIB_DIR}"',
      "CMAKE_INSTALL_RPATH #{rpaths.join(";")}"

    mkdir "build" do
      cmake_args = std_cmake_args + %W[
        -DCMAKE_CXX_COMPILER=#{ENV["CXX"]}
        -DCXX_FLAGS=#{ENV["CXXFLAGS"]}
        -DCMAKE_CXX_STANDARD=17
        -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{py_ver_nodot}.#{lib_ext}
        -DPython_FIND_FRAMEWORK=NEVER
        -DENABLE_GUI=OFF
        -DENABLE_GFX=OFF
        -DENABLE_INFO=OFF
        -DCMAKE_VERBOSE_MAKEFILE=ON
      ]
      if OS.linux?
        cmake_args << "-DZLIB_ROOT=#{Formula["zlib"].opt_prefix}"
        cmake_args << "-DZLIB_LIBRARY=#{Formula["zlib"].opt_lib}/libz.#{lib_ext}"
        cmake_args << "-DZLIB_INCLUDE_DIR=#{Formula["zlib"].opt_include}"
      end

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
        -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{py_ver_nodot}.#{lib_ext}
        -DPython_FIND_FRAMEWORK=NEVER
        -DCOMPOUND_LIB=#{buildpath}/build/compounds.chemlib
        -DPARASAIL_INCLUDE_DIR=#{Formula["brewsci/bio/parasail"].opt_include}
        -DPARASAIL_LIBRARY=#{Formula["brewsci/bio/parasail"].opt_lib}/libparasail.#{lib_ext}
        -DOPEN_MM_LIBRARY=#{openmm_libs_base}/lib/libOpenMM.#{lib_ext}
        -DOPEN_MM_INCLUDE_DIR=#{openmm_libs_base}/include
        -DOPEN_MM_PLUGIN_DIR=#{openmm_libs_base}/lib/plugins
        -DENABLE_MM=ON
        -DUSE_RPATH=ON
        -DOPTIMIZE=ON
        -DENABLE_PARASAIL=ON
        -DCOMPILE_TMTOOLS=OFF
        -DENABLE_GFX=ON
        -DENABLE_GUI=ON
        -DENABLE_INFO=ON
        -DUSE_SHADER=ON
        -DUSE_DOUBLE_PRECISION=OFF
        -DCMAKE_VERBOSE_MAKEFILE=ON
      ]
      if OS.linux?
        cmake_args << "-DZLIB_ROOT=#{Formula["zlib"].opt_prefix}"
        cmake_args << "-DZLIB_LIBRARY=#{Formula["zlib"].opt_lib}/libz.#{lib_ext}"
        cmake_args << "-DZLIB_INCLUDE_DIR=#{Formula["zlib"].opt_include}"
      end

      system "cmake", "..", *cmake_args
      system "make", "VERBOSE=1"
      system "make", "install"
    end
    prefix.install "examples"
  end

  def caveats
    <<~EOS
      You may need to install the following packages to use certain python bindings:
      (Refer to https://openstructure.org/docs/2.9.2/bindings/bindings/)

        - blast
        - brewsci/bio/dssp
        - brewsci/bio/hh-suite
        - mmseqs2
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/ost -h 2>&1", 255)
    cp_r prefix/"examples", testpath
    system "#{bin}/ost", "compare-structures", "-m", testpath/"examples/scoring/model.pdb",
                         "-r", testpath/"examples/scoring/reference.cif.gz",
                         "--lddt", "--local-lddt", "--qs-score"
    assert_path_exists testpath/"out.json"
  end
end
