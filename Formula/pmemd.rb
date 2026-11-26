class Pmemd < Formula
  desc "Set of programs for biomolecular simulation and analysis"
  homepage "https://ambermd.org/AmberTools.php"
  url "https://ambermd.org/downloads/pmemd26_rc7.tar.bz2"
  version "26.0"
  sha256 "0478ccce892f3525e995e9c85458d552c6060b73dd28acd03c366e61ecf23a14"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT"]

  depends_on "cmake" => :build
  depends_on "brewsci/bio/ambertools"
  depends_on "gcc" # for gfortran
  depends_on :macos
  depends_on "netcdf"
  depends_on "open-mpi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses" => :build
  uses_from_macos "perl"
  uses_from_macos "zlib"

  def install
    # Use GCC-16 Fortran compiler
    inreplace "cmake/AmberCompilerConfig.cmake", "Fortran gfortran", "Fortran gfortran-16"
    # fix rpath of pysander and pytraj
    args = %W[
      -DCOMPILER=CLANG
      -DBLA_VENDOR=Apple
      -DOPENMP=FALSE
      -DMPI=TRUE
      -DCUDA=FALSE
      -DINSTALL_TESTS=TRUE
      -DBUILD_PERL=FALSE
      -DBUILD_GUI=FALSE
      -DPMEMD_ONLY=TRUE
      -DCHECK_UPDATES=FALSE
      -DDOWNLOAD_MINICONDA=FALSE
      -DBUILD_PYTHON=FALSE
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    # install only "pmemd" executables
    binaries = ["pmemd", "pmemd.MPI", "pmemd.decomp"]
    binaries.each do |binary|
      bin.install "build/src/pmemd/src/#{binary}"
      # Binaries link @rpath/libemil.dylib and @rpath/libkmmd.dylib, both shipped
      # by the ambertools dependency. They are copied directly (no `cmake
      # --install`), so add an rpath to ambertools' lib to resolve them.
      MachO::Tools.add_rpath((bin/binary).to_s, formula_opt_lib("ambertools").to_s)
      # install_name_tool invalidates the code signature; re-sign ad-hoc.
      system "codesign", "--force", "--sign", "-", bin/binary
    end
    # install pmemd's own MPI EMIL library (not provided by ambertools)
    lib.install "build/AmberTools/src/emil/libemil_mpi.dylib"
  end

  test do
    assert_match "Unit  115 Error", shell_output("#{bin}/pmemd 2>&1")
  end
end
