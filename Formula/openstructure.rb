class Openstructure < Formula
  include Language::Python::Virtualenv

  # cite Biasini_2013: "https://doi.org/10.1107/S0907444913007051"
  desc "Modular software framework for molecular modelling and visualization"
  homepage "https://openstructure.org"
  url "https://git.scicore.unibas.ch/schwede/openstructure/-/archive/2.11.0/openstructure-2.11.0.tar.gz"
  sha256 "46c91d0499f54818e3039cb6d51c9cc296b7e1a2ff34521dcc207cee18c38b60"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256                               arm64_sequoia: "e42dd1a5f356833a126a9d41c0f5e014ce61d46c40d3a1c9dc5372ab563de349"
    sha256                               arm64_sonoma:  "dcfd1cfcee02842b3e1af9f07d8d5759f230751e41f8fe96517c2ac929e280cb"
    sha256 cellar: :any,                 ventura:       "c9101c22cebbf661b17d97bd9ef24a59e9f6a57d094e6e6a836b8ccbb5bbc92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b8b6e55634cdad24550fd6a69a4eeaa0040da58d6b42306ac92eb0da799be7d"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "wget" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/openmm@7"
  depends_on "brewsci/bio/parasail"
  depends_on "brewsci/bio/voronota"
  depends_on "fftw"
  depends_on "gcc" # for `tmalign` and `tmscore` implemented in Fortran
  depends_on "glew"
  depends_on "glfw"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openblas"
  depends_on "pyqt@5"
  depends_on "python@3.13"
  depends_on "qt@5"
  depends_on "scipy"
  depends_on "sip"
  depends_on "sqlite"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build # Requires latest libc++ to compile
    depends_on "libpq"
  end

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "opencl-icd-loader"
  end

  resource "dockq" do
    url "https://files.pythonhosted.org/packages/c1/a5/df80285b0f2e5b94562ccc1656ba8f3eaff34f7428ea04f26dad28894ae0/dockq-2.1.3.tar.gz"
    sha256 "50c4e2b4bced3bf865b12061ec0b56e23de1383dc70b445441848224f6c72c0d"
  end

  def python3
    "python3.13"
  end

  def install
    py_ver = Language::Python.major_minor_version python3
    py_ver_nodot = py_ver.to_s.delete(".")

    if OS.mac?
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
      ENV.prepend "LDFLAGS", "-undefined dynamic_lookup -Wl,-export_dynamic"
    elsif OS.linux?
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{Formula["gcc"].version.major}"
      ENV.prepend "LDFLAGS", "-Wl,--allow-shlib-undefined,--export-dynamic -lstdc++"
    end

    # Install python packages using virtualenv pip
    venv = virtualenv_create libexec, which(python3)
    ENV.prepend_path "PATH", libexec/"bin"
    ENV.prepend_create_path "PYTHONPATH", venv.site_packages
    site_packages_path = Language::Python.site_packages python3
    (prefix/site_packages_path/"homebrew-openstructure.pth").write venv.site_packages
    system libexec/"bin/python", "-m", "pip", "install", "-U", *%w[
      pip
      setuptools
      setuptools-scm
      wheel
    ]
    system libexec/"bin/python", "-m", "pip", "install", *%w[
      biopython<2.0
      networkx<3.0
      numpy<2.0
      pandas<2.3
      parallelbar<3.0
    ]
    venv.pip_install_and_link resource("dockq")

    lib_ext = OS.mac? ? "dylib" : "so"

    mkdir "build" do
      cmake_args = std_cmake_args + %W[
        -DCMAKE_CXX_COMPILER=#{ENV["CXX"]}
        -DCXX_FLAGS=#{ENV["CXXFLAGS"]}
        -DCMAKE_CXX_STANDARD=17
        -DCMAKE_PREFIX_PATH=#{HOMEBREW_PREFIX}
        -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{py_ver_nodot}.#{lib_ext}
        -DENABLE_GUI=OFF
        -DENABLE_GFX=OFF
        -DENABLE_INFO=OFF
        -DUSE_RPATH=ON
      ]

      system "cmake", "..", *cmake_args
      system "make", "VERBOSE=1"

      # the components.cif.gz file is updated weekly (Wednesday 00:00 UTC)
      system "wget", "https://files.wwpdb.org/pub/pdb/data/monomers/components.cif.gz"

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
        -DCMAKE_PREFIX_PATH=#{HOMEBREW_PREFIX}
        -DPREFIX=#{prefix}
        -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
        -DBoost_INCLUDE_DIRS=#{Formula["boost"].opt_include}
        -DBOOST_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{py_ver_nodot}.#{lib_ext}
        -DCOMPOUND_LIB=#{buildpath}/build/compounds.chemlib
        -DPARASAIL_INCLUDE_DIR=#{Formula["brewsci/bio/parasail"].opt_include}
        -DPARASAIL_LIBRARY=#{Formula["brewsci/bio/parasail"].opt_lib}/libparasail.#{lib_ext}
        -DOPEN_MM_LIBRARY=#{Formula["brewsci/bio/openmm@7"].opt_lib}/libOpenMM.#{lib_ext}
        -DOPEN_MM_INCLUDE_DIR=#{Formula["brewsci/bio/openmm@7"].opt_include}
        -DOPEN_MM_PLUGIN_DIR=#{Formula["brewsci/bio/openmm@7"].opt_lib}/plugins
        -DENABLE_MM=ON
        -DUSE_RPATH=ON
        -DOPTIMIZE=ON
        -DENABLE_PARASAIL=ON
        -DCOMPILE_TMTOOLS=ON
        -DENABLE_GFX=ON
        -DENABLE_GUI=ON
        -DENABLE_INFO=ON
        -DUSE_SHADER=ON
        -DUSE_DOUBLE_PRECISION=OFF
      ]

      system "cmake", "..", *cmake_args
      system "make", "VERBOSE=1"
      system "make", "check" # Test suite for built binaries
      system "make", "install"
    end

    pkgshare.install "examples"
    prefix.install_metafiles
  end

  def caveats
    <<~EOS
      You may need to install the following packages to use certain python bindings:
      (Refer to https://openstructure.org/docs/bindings/bindings/)

        - blast
        - brewsci/bio/clustal-w
        - brewsci/bio/dssp
        - brewsci/bio/hh-suite
        - brewsci/bio/msms
        - mmseqs2
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/ost -h 2>&1", 255)
    cp_r pkgshare/"examples", testpath
    system "#{bin}/ost", "compare-structures", "-m", testpath/"examples/scoring/model.pdb",
                         "-r", testpath/"examples/scoring/reference.cif.gz",
                         "--lddt", "--local-lddt", "--qs-score"
    assert_path_exists testpath/"out.json"
  end
end
