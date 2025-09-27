class Libcootapi < Formula
  include Language::Python::Virtualenv

  desc "Library of Crystallographic Object-Oriented Toolkit"
  homepage "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/"
  url "https://github.com/pemsley/coot/archive/refs/tags/Release-1.1.18.tar.gz"
  sha256 "c6e2864023c0bc83278c6fd760af704fd955616a007f00d61452b015f892f463"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only", "GPL-2.0-or-later"]
  head "https://github.com/pemsley/coot.git", branch: "main"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "adwaita-icon-theme"
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/clipper4coot"
  depends_on "brewsci/bio/gemmi"
  depends_on "brewsci/bio/libccp4"
  depends_on "brewsci/bio/mmdb2"
  depends_on "brewsci/bio/raster3d"
  depends_on "brewsci/bio/ssm"
  depends_on "cairo"
  depends_on "coordgen"
  depends_on "dwarfutils"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmp"
  depends_on "graphene"
  depends_on "gsl"
  depends_on "gtk4"
  depends_on "harfbuzz"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "maeparser"
  depends_on "nanobind"
  depends_on "openblas"
  depends_on "pango"
  depends_on "py3cairo"
  depends_on "python@3.13"
  depends_on "rdkit"
  depends_on "robin-map"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  def python3
    "python3.13"
  end

  def install
    ENV.cxx11
    ENV.libcxx
    # Get Python location
    venv = virtualenv_create(libexec, python3)
    # (prefix/Language::Python.site_packages(python3)/"homebrew-coot.pth").write venv.site_packages
    ENV.prepend_path "PYTHONPATH", venv.site_packages
    # ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)

    rdkit_prefix = Formula["rdkit"].opt_prefix
    fftw2_prefix = Formula["clipper4coot"].opt_prefix/"fftw2"

    # inreplace "CMakeLists.txt", "find_package(Python REQUIRED)", "find_package(Python REQUIRED COMPONENTS Interpreter Development.Module)"
    system "cmake", "-S", ".", "-B", "build-libcootapi",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                    "-DCMAKE_PREFIX_PATH=#{HOMEBREW_PREFIX}",
                    "-DGEMMI_DIR=#{Formula["gemmi"].opt_lib}/cmake/gemmi",
                    "-DRDKit_DIR=#{rdkit_prefix}/lib/cmake/rdkit",
                    "-DSSM_INCLUDE_DIR=#{Formula["brewsci/bio/ssm"].opt_include}",
                    "-DSSM_LIBRARY=#{Formula["brewsci/bio/ssm"].opt_lib}/libssm.#{OS.mac? ? "dylib" : "so"}",
                    "-DCLIPPER-CORE_LIBRARY=#{Formula["brewsci/bio/clipper4coot"].opt_lib}/libclipper-core.#{OS.mac? ? "dylib" : "so"}",
                    "-DCLIPPER-MMDB_LIBRARY=#{Formula["brewsci/bio/clipper4coot"].opt_lib}/libclipper-mmdb.#{OS.mac? ? "dylib" : "so"}",
                    "-DCLIPPER-CCP4_LIBRARY=#{Formula["brewsci/bio/clipper4coot"].opt_lib}/libclipper-ccp4.#{OS.mac? ? "dylib" : "so"}",
                    "-DCLIPPER-CONTRIB_LIBRARY=#{Formula["brewsci/bio/clipper4coot"].opt_lib}/libclipper-contrib.#{OS.mac? ? "dylib" : "so"}",
                    "-DCLIPPER-MINIMOL_LIBRARY=#{Formula["brewsci/bio/clipper4coot"].opt_lib}/libclipper-minimol.#{OS.mac? ? "dylib" : "so"}",
                    "-DCLIPPER-CIF_LIBRARY=#{Formula["brewsci/bio/clipper4coot"].opt_lib}/libclipper-cif.#{OS.mac? ? "dylib" : "so"}",
                    "-DCLIPPER-CORE_INCLUDE_DIR=#{Formula["brewsci/bio/clipper4coot"].opt_include}",
                    "-DCLIPPER-MMDB_INCLUDE_DIR=#{Formula["brewsci/bio/clipper4coot"].opt_include}",
                    "-DCLIPPER-CCP4_INCLUDE_DIR=#{Formula["brewsci/bio/clipper4coot"].opt_include}",
                    "-DMMDB2_LIBRARY=#{Formula["brewsci/bio/mmdb2"].opt_lib}/libmmdb2.#{OS.mac? ? "dylib" : "so"}",
                    "-DMMDB2_INCLUDE_DIR=#{Formula["brewsci/bio/mmdb2"].opt_include}",
                    "-DFFTW2_INCLUDE_DIRS=#{fftw2_prefix}/include",
                    "-DFFTW2_LIBRARY=#{fftw2_prefix}/lib/libfftw.#{OS.mac? ? "dylib" : "so"}",
                    "-DRFFTW2_LIBRARY=#{fftw2_prefix}/lib/librfftw.#{OS.mac? ? "dylib" : "so"}",
                    "-DPython_EXECUTABLE=#{venv.root}/bin/python3"
    system "cmake", "--build", "build-libcootapi"
    system "cmake", "--install", "build-libcootapi"
  end

  # test block is not tested now.
  test do
    # Return True
    system "true"
  end
end
