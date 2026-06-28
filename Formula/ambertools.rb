class Ambertools < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Set of programs for biomolecular simulation and analysis"
  homepage "https://ambermd.org/AmberTools.php"
  url "https://ambermd.org/downloads/ambertools26_rc7.tar.bz2"
  version "26.0"
  sha256 "5d46eef3c2bb7d5bf9e8c0c38add34406ea67e3f0e4097ac9d11d8a544538c9c"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_tahoe:   "454f711d98d696228b9b27d2fa7b8ec827c83575b079de208f088cac0b244d12"
    sha256 arm64_sequoia: "e8038f666473cd9eae638ef4f193691ced9fe6d9a9f805f3ac82bb599f953479"
    sha256 arm64_sonoma:  "9751456357d99070d09a285cbeeb93a99ea397b5d553ac3495412c0bf81248ba"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build # for rpds-py
  depends_on "arpack"
  depends_on "boost"
  depends_on "fftw"
  depends_on "gcc@14" # for gfortran
  depends_on "libomp"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxext"
  depends_on "libxt"
  depends_on :macos
  depends_on "maturin" # for rpds-py
  depends_on "netcdf"
  depends_on "nlopt"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python-tk@3.12"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses" => :build
  uses_from_macos "perl"
  uses_from_macos "zlib"

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/20/af/3f2f423103f1113b36230496629986e0ef7e199d2aa8392452b484b38ced/rpds_py-0.30.0.tar.gz"
    sha256 "dd8ff7cf90014af0c0f787eea34794ebf6415242ee1d6fa91eaba725cc441e84"
  end

  def python3
    "python3.12"
  end

  def install
    # move the destination of wrapped progs to libexec/bin
    inreplace "cmake/InstallWrapped.cmake" do |s|
      s.gsub!("${WRAPPER_SCRIPT} DESTINATION ${BINDIR}", "${WRAPPER_SCRIPT} DESTINATION #{bin}")
      s.gsub!("${EXECUTABLE} DESTINATION ${BINDIR}", "${EXECUTABLE} DESTINATION #{libexec}/bin")
      s.gsub!("source ", "# source ")
      s.gsub!("$AMBERHOME/bin/wrapped_progs", "#{libexec}/bin/wrapped_progs")
      s.gsub!('INSTALL_RPATH "@loader_path/../../${LIBDIR}"', "INSTALL_RPATH #{lib}")
    end
    # fix hard-coded AMBERHOME
    inreplace ["AmberTools/src/leap/tleap", "AmberTools/src/leap/xleap"] do |s|
      s.gsub!('AMBERHOME="$(dirname "$(cd "$(dirname "$0")" && pwd)")"', "AMBERHOME=\"#{opt_prefix}\"")
    end
    # omit "Boost.System" since Boost 1.69 and has no compiled library in recent Boost.
    inreplace "cmake/3rdPartyTools.cmake" do |s|
      s.gsub!("find_package(Boost COMPONENTS thread system program_options",
              "find_package(Boost COMPONENTS thread program_options")
      s.gsub!("program_options regex system thread timer)",
             "program_options regex thread timer)\n
              add_library(boost_system INTERFACE)\n
              set_property(TARGET boost_system PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${Boost_INCLUDE_DIRS})")
    end

    # pip install required python packages
    venv = virtualenv_create(libexec, python3)
    python = venv.root/"bin/python3"
    resources = %w[numpy==1.26.4
                   scipy
                   matplotlib
                   setuptools
                   pandas
                   gemmi==0.7.5
                   biopython
                   rich
                   freesasa
                   scikit-learn
                   sympy
                   pydantic
                   psutil
                   networkx
                   cython
                   numba]
    system python, "-m", "pip", "install", *resources
    # rpds-py must be built from source to work around an issue with cleanup
    venv.pip_install(resource("rpds-py"), build_isolation: false)
    # resource("rpds-py").stage do
    #   system python, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true), "."
    # end
    # numba's PyPI wheels bake in a CI-only rpath (/Users/runner/...) for
    # libomp, which `brew linkage --strict` flags as a missing rpath. Repoint
    # it to Homebrew's libomp so @rpath/libomp.dylib resolves, then ad-hoc
    # re-sign each touched file (install_name_tool invalidates the signature).
    bad_rpath = "/Users/runner/miniconda3/envs/test/lib"
    libomp_lib = formula_opt_lib("libomp").to_s
    Dir.glob(libexec/"lib/python3.12/site-packages/numba/**/*.so").each do |so|
      next unless MachO.open(so).rpaths.include?(bad_rpath)

      MachO::Tools.change_rpath(so, bad_rpath, libomp_lib)
      system "codesign", "--force", "--sign", "-", so
    end
    system python3, "update_amber", "--update"
    # Use GCC-14 Fortran compiler
    inreplace "cmake/AmberCompilerConfig.cmake", "Fortran gfortran", "Fortran gfortran-14"
    # fix rpath of pysander and pytraj
    inreplace "AmberTools/src/pytraj/CMakeLists.txt",
              "-Wl,-rpath,@loader_path/../../../../..",
              "-Wl,-rpath,#{lib}"
    inreplace "AmberTools/src/pysander/CMakeLists.txt",
              "-Wl,-rpath,@loader_path/../../..",
              "-Wl,-rpath,#{lib}"
    inreplace "AmberTools/src/pysander/CMakeLists.txt",
              '\"${PYTHON_EXECUTABLE}\"',
              '\"${PYTHON_EXECUTABLE}\" ${RPATH_ARG}' # need to add RPATH_ARG on installation
    inreplace "AmberTools/src/mpi4py-3.1.4/CMakeLists.txt",
              "-Wl,-rpath,@loader_path/../../..",
              "-Wl,-rpath,#{lib}"
    args = %W[
      -DCOMPILER=CLANG
      -DBLA_VENDOR=Apple
      -DOPENMP=FALSE
      -DMPI=FALSE
      -DCUDA=FALSE
      -DINSTALL_TESTS=TRUE
      -DDOWNLOAD_MINICONDA=FALSE
      -DPYTHON_EXECUTABLE=#{venv.root}/bin/python3
      -DFORCE_EXTERNAL_LIBS=boost
      -DBOOST_ROOT=#{formula_opt_prefix("boost")}
      -DBOOST_INCLUDEDIR=#{formula_opt_include("boost")}
      -DBOOST_LIBRARYDIR=#{formula_opt_lib("boost")}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # Remove AmberTools directory
    rm_r Dir["#{prefix}/AmberTools"]
    rm_r "#{prefix}/config.h"
    Dir.glob("#{bin}/*.py") do |script|
      rewrite_shebang detected_python_shebang(use_python_from_path: true), script
    end
  end

  def caveats
    <<~EOS
      You may need to add AMBERHOME to your environment variables, e.g.
        #{Utils::Shell.export_value("AMBERHOME", opt_prefix)}
    EOS
  end

  test do
    ENV["AMBERHOME"] = opt_prefix
    assert_match "Usage", shell_output("#{bin}/cpptraj --help 2>&1")
    assert_match "Usage", shell_output("#{bin}/FEW.pl -h 2>&1")
    assert_match "usage", shell_output("#{bin}/MMPBSA.py -h 2>&1")
  end
end
