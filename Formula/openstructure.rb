class Openstructure < Formula
  desc "Modular software framework for molecular modelling and visualization"
  homepage "https://openstructure.org"
  url "https://git.scicore.unibas.ch/schwede/openstructure/-/archive/2.9.3/openstructure-2.9.3.tar.gz"
  sha256 "b5958ada252a3912a71da0cefb0313a4291ac6b17c93d6e0a61d361ee62de92e"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "boost-python3@1.87"
  depends_on "boost@1.85"
  depends_on "clustal-w"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "parasail"
  depends_on "python@3.12"
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
    url "https://raw.githubusercontent.com/eunos-1128/openstructure/a37429f40ffc9802158444a431fc405e3724649c/boost-1_85.patch"
    sha256 "6fc81637723677b8ee3b07a79174d6100c7c4914a367a0425d0724495de953b8"
  end

  def python3
    "python3.12"
  end

  def install
    xy = Language::Python.major_minor_version python3
    xy_nodot = xy.to_s.delete(".")
    ENV.prepend_path "PATH", "#{HOMEBREW_PREFIX}/bin/python#{xy}"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system python3, "-m", "pip", "install", "--prefix=#{libexec}",
      "numpy", "pandas", "scipy", "networkx", "OpenMM", "PyQt5"

    lib_ext = OS.mac? ? "dylib" : "so"

    mkdir "build" do
      args = %W[
        -DCMAKE_CXX_STANDARD=17
        -DPython_EXECUTABLE=#{Formula["python@#{xy}"].opt_prefix}/bin/python#{xy}
        -DBOOST_ROOT=#{Formula["boost@1.85"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost@1.85"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3@1.87"].opt_lib}/libboost_python#{xy_nodot}.#{lib_ext}
        -DOPTIMIZE=1
        -DENABLE_MM=1
        -DOPEN_MM_LIBRARY=#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/lib
        -DOPEN_MM_INCLUDE_DIR=#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/include
        -DOPEN_MM_PLUGIN_DIR=#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/lib/plugins
        -DENABLE_PARASAIL=1
        -DCOMPILE_TMTOOLS=1
        -DENABLE_GFX=1
        -DENABLE_GUI=1
        -DENABLE_INFO=1
        -DCMAKE_VERBOSE_MAKEFILE=ON
      ] + std_cmake_args
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
      args = %W[
        -DPREFIX=#{prefix}
        -DCMAKE_CXX_STANDARD=17
        -DPython_EXECUTABLE=#{Formula["python@#{xy}"].opt_prefix}/bin/python#{xy}
        -DBOOST_ROOT=#{Formula["boost@1.85"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost@1.85"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3@1.87"].opt_lib}/libboost_python#{xy_nodot}.#{lib_ext}
        -DCOMPOUND_LIB=#{buildpath}/build/compounds.chemlib
        -DCMAKE_VERBOSE_MAKEFILE=ON
      ] + std_cmake_args

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
