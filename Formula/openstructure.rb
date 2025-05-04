class Openstructure < Formula
  include Language::Python::Virtualenv

  # cite Biasini_2013: "https://doi.org/10.1107/S0907444913007051"
  desc "Modular software framework for molecular modelling and visualization"
  homepage "https://openstructure.org"
  url "https://git.scicore.unibas.ch/schwede/openstructure/-/archive/2.9.3/openstructure-2.9.3.tar.gz"
  sha256 "b5958ada252a3912a71da0cefb0313a4291ac6b17c93d6e0a61d361ee62de92e"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256                               arm64_sequoia: "b05a39dfc022e5489a5b31411492a5319a6c7f7539ed907df2aa421fcd110b03"
    sha256                               arm64_sonoma:  "edc153034712174b9da5584dffdb29e812d92593f4d1ceb8be1c5025eb8be191"
    sha256 cellar: :any,                 ventura:       "ecc260ae6111215e5e04a74a58097267e0cc20cc01aaaa1b7972a060058e8c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f001779a1f2f75454e6d95a398d2a7b982ffcb87d99c2df356eb218f822bae70"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/clustal-w"
  depends_on "brewsci/bio/openmm@7"
  depends_on "brewsci/bio/parasail"
  depends_on "brewsci/bio/sip@4"
  depends_on "brewsci/bio/usalign"
  depends_on "brewsci/bio/voronota"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "glew"
  depends_on "glfw"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openblas"
  depends_on "pyqt@5"
  depends_on "python@3.13"
  depends_on "qt@5"
  depends_on "scipy"
  depends_on "sqlite"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm"
    depends_on "postgresql@15"
  end

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "gcc"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "opencl-icd-loader"
  end

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
    url "https://raw.githubusercontent.com/eunos-1128/openstructure/1fbcfe506352da6f3c95a1752d3d54ef089fa12b/homebrew.patch"
    sha256 "ce4f81a39087817023bdca23c124fb5e5f4800378aa0f374c89458dcbc39b5a1"
  end

  def python3
    "python3.13"
  end

  def install
    py_ver = Language::Python.major_minor_version python3
    py_ver_nodot = py_ver.to_s.delete(".")

    if OS.mac?
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
      ENV.append "LDFLAGS", "-undefined dynamic_lookup -Wl,-export_dynamic"
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
        -DCOMPILE_TMTOOLS=OFF
        -DENABLE_GFX=ON
        -DENABLE_GUI=ON
        -DENABLE_INFO=ON
        -DUSE_SHADER=ON
        -DUSE_DOUBLE_PRECISION=OFF
      ]

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
