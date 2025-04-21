class Openstructure < Formula
  desc "Modular software framework for molecular modelling and visualization"
  homepage "https://openstructure.org"
  url "https://git.scicore.unibas.ch/schwede/openstructure/-/archive/2.9.3/openstructure-2.9.3.tar.gz"
  sha256 "b5958ada252a3912a71da0cefb0313a4291ac6b17c93d6e0a61d361ee62de92e"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "gcc" => :build
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

  resource "components" do
    url "https://files.wwpdb.org/pub/pdb/data/monomers/components.cif.gz"
    sha256 "9efba276fc378cde50a2e3dfe27390f0737059c29ea12019d20cfc978f76bf74"
  end

  def python3
    "python3.12"
  end

  def install
    ENV.cxx11

    xy = Language::Python.major_minor_version python3
    ENV.prepend_path "PATH", "#{HOMEBREW_PREFIX}/bin/python#{xy}"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system python3, "-m", "pip", "install", "--prefix=#{libexec}",
      "numpy", "pandas", "scipy", "networkx", "OpenMM", "PyQt5"

    inreplace "modules/seq/alg/src/hmm_pseudo_counts.cc",
      "#include <boost/filesystem/convenience.hpp>",
      "#include <boost/filesystem.hpp>"

    inreplace "modules/seq/alg/src/hmm_pseudo_counts.cc" do |s|
      s.gsub! "boost::filesystem::extension", "boost::filesystem::path(filename).extension().string"
    end

    lib_ext = OS.mac? ? "dylib" : "so"

    mkdir "build" do
      args = std_cmake_args + %W[
        -DPREFIX=#{prefix}
        -DCMAKE_CXX_STANDARD=11
        -DCMAKE_CXX_COMPILER=#{ENV["CXX"]}
        -DPython_EXECUTABLE=#{Formula["python@#{xy}"].opt_prefix}/bin/python#{xy}
        -DBOOST_ROOT=#{Formula["boost@1.85"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost@1.85"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3@1.87"].opt_lib}/libboost_python#{xy}.#{lib_ext}
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
      ]
      system "cmake", "..", *args
      system "make"

      resource("components").fetch
      (buildpath/"build").install resource("components").cached_download

      system "#{prefix}/stage/bin/chemdict_tool", "create",
              "components.cif.gz", "compounds.chemlib",
              "pdb", "-i"
      system "#{prefix}/stage/bin/chemdict_tool", "update",
              buildpath/"modules/conop/data/charmm.cif",
              "compounds.chemlib", "charmm"
    end

    # Re-configure with compound library
    args = %W[
      ..
      -DPREFIX=#{prefix}
      -DCMAKE_CXX_STANDARD=11
      -DCMAKE_CXX_COMPILER=#{ENV["CXX"]}
      -DPython_EXECUTABLE=#{Formula["python@#{xy}"].opt_prefix}/bin/python#{xy}
      -DBOOST_ROOT=#{Formula["boost@1.85"].opt_prefix}
      -DBoost_INCLUDE_DIRS=#{Formula["boost@1.85"].opt_include}
      -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3@1.87"].opt_lib}/libboost_python#{xy}.#{lib_ext}
      -DCOMPOUND_LIB=#{buildpath}/build/compounds.chemlib
      -DCMAKE_VERBOSE_MAKEFILE=ON
    ] + std_cmake_args

    system "cmake", *args
    system "bash", "-lc", "make VERBOSE=1 2>&1 | tee build.log"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ost -h")
  end
end
