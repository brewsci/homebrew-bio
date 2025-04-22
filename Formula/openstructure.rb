class Openstructure < Formula
  desc "Modular software framework for molecular modelling and visualization"
  homepage "https://openstructure.org"
  url "https://git.scicore.unibas.ch/schwede/openstructure/-/archive/2.9.3/openstructure-2.9.3.tar.gz"
  sha256 "b5958ada252a3912a71da0cefb0313a4291ac6b17c93d6e0a61d361ee62de92e"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "clustal-w"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "parasail"
  depends_on "pyqt@5"
  depends_on "python@3.13"
  depends_on "qt@5"
  depends_on "sip"
  depends_on "sqlite3"
  depends_on "voronota"

  uses_from_macos "zlib"

  resource "components-cif" do
    url "https://files.wwpdb.org/pub/pdb/data/monomers/components.cif.gz"
    sha256 "9efba276fc378cde50a2e3dfe27390f0737059c29ea12019d20cfc978f76bf74"
  end

  patch do
    url "https://raw.githubusercontent.com/eunos-1128/openstructure/00ccfd2f1da1f978aead48391798b5924dd2f3c5/boost.patch"
    sha256 "88a253ca45e07e4ee3bcf9436975ed060bb943194eecc0ca46f4556553c62746"
  end

  def python3
    "python3.13"
  end

  def install
    ENV.cxx11
    ENV.libcxx

    xy = Language::Python.major_minor_version python3
    xy_nodot = xy.to_s.delete(".")
    ENV.prepend_path "PATH", "#{HOMEBREW_PREFIX}/bin/python#{xy}"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "pip3", "install", "--prefix=#{libexec}",
      "numpy", "pandas", "scipy", "networkx", "OpenMM"

    lib_ext = OS.mac? ? "dylib" : "so"

    # Set RPATH to `#{prefix}/lib and OpenMM libs`
    inreplace buildpath/"CMakeLists.txt",
      'CMAKE_INSTALL_RPATH "$ORIGIN/../${LIB_DIR}"',
      "CMAKE_INSTALL_RPATH #{lib}:#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/lib"

    mkdir "build" do
      args = std_cmake_args + %W[
        -DCMAKE_CXX_COMPILER=#{ENV["CXX"]}
        -DCMAKE_CXX_STANDARD=17
        -DPython_EXECUTABLE=#{Formula["python@#{xy}"].opt_prefix}/bin/python#{xy}
        -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{xy_nodot}.#{lib_ext}
        -DCMAKE_VERBOSE_MAKEFILE=1
        -DUSE_RPATH=1
      ]
      args << "-DCXX_FLAGS=-stdlib=libc++" if OS.mac?
      system "cmake", "..", *args
      system "make"

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
        -DENABLE_GUI=1
        -DENABLE_INFO=1
        -DCMAKE_VERBOSE_MAKEFILE=1
      ]
      args << "-DCXX_FLAGS=-stdlib=libc++" if OS.mac?

      system "cmake", "..", *args
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ost -h")
  end
end
