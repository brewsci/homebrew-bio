class Ambertools < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Set of programs for biomolecular simulation and analysis"
  homepage "https://ambermd.org/AmberTools.php"
  url "https://ambermd.org/downloads/ambertools25_rc7.tar.bz2"
  version "25.update3"
  sha256 "ac009b2adeb25ccd2191db28905b867df49240e038dc590f423edf0d84f8a13b"
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
  depends_on "fftw"
  depends_on "gcc@13" # for gfortran
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

    # pip install required python packages
    venv = virtualenv_create(libexec, python3)
    python = venv.root/"bin/python3"
    # rpds-py must be built from source to work around an issue with cleanup
    resource("rpds-py").stage do
      system python, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true), "."
    end
    resources = %w[numpy==1.26.4 scipy matplotlib setuptools rdkit pdb2pqr]
    system python, "-m", "pip", "install", *resources
    system python3, "update_amber", "--update"
    # Use GCC-13 Fortran compiler
    inreplace "cmake/AmberCompilerConfig.cmake", "Fortran gfortran", "Fortran gfortran-13"
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
      -DFORCE_DISABLE_LIBS=boost
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
    resource "homebrew-testdata" do
      url "https://files.rcsb.org/download/3QUG.pdb"
      sha256 "7b71128bedcd7ebdea42713942a30af590b3cf514726485f9aa27430c3999657"
    end
    resource("homebrew-testdata").stage testpath
    system("#{bin}/reduce -NOFLIP -Quiet 3QUG.pdb > 3QUG_h.pdb 2>&1")
    assert_match "add=1978, rem=0, adj=70", File.read("3QUG_h.pdb")
  end
end
