class Viennarna < Formula
  # cite Lorenz_2011: "https://doi.org/10.1186/1748-7188-6-26"
  desc "Prediction and comparison of RNA secondary structures"
  homepage "https://www.tbi.univie.ac.at/~ronny/RNA/"
  url "https://www.tbi.univie.ac.at/RNA/download/sourcecode/2_7_x/ViennaRNA-2.7.0.tar.gz"
  sha256 "9a99fd68ed380894defb4d5e6a8a2871629270028cdf7f16f0a05da6e8c71473"
  license :cannot_represent
  head "https://github.com/ViennaRNA/ViennaRNA.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool"  => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "texinfo" => :build
  depends_on "gmp"
  depends_on "gsl"
  depends_on "mpfr"
  depends_on "openblas"
  depends_on "perl"
  depends_on "python@3.14"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  patch do
    url "https://raw.githubusercontent.com/bioconda/bioconda-recipes/871a0e5a3b9af8bb0b8e033620aae08f32390bd0/recipes/viennarna/fix_python_module_copy.patch"
    sha256 "8ff562202871a56ec163e5d805bd1e312bfe984b430d4e24f9e4ece2d0987ef5"
  end

  patch :DATA

  def python3
    which("python3.14")
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?
    ENV.append "CXXFLAGS", "-std=c++17" # for Kinwalker
    # Fix dlib build with newer compilers
    inreplace "src/dlib-19.24/dlib/global_optimization/find_max_global.h",
              "::template go(std::forward<T>(f),a))",
              "::go(std::forward<T>(f),a))"
    # regenerate configure file
    system "autoreconf", "-fvi"

    ENV.append "LDFLAGS", "-Wl,-headerpad_max_install_names"
    args = %W[
      --prefix=#{prefix}
      --with-kinwalker
      --with-cluster
      --disable-lto
      --without-cla
    ]
    if OS.mac?
      # Work around "checking for OpenMP flag of C compiler... unknown"
      args += [
        "ac_cv_prog_c_openmp=-Xpreprocessor -fopenmp",
        "ac_cv_prog_cxx_openmp=-Xpreprocessor -fopenmp",
        "LDFLAGS=-lomp",
      ]
    end
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      Formula["python@#{xy}"].opt_include/"python#{xy}"
    end
    site_packages = prefix/Language::Python.site_packages(python3)
    ENV["PYTHON3"] = python3
    ENV["PYTHON3_DIR"] = site_packages
    ENV["PYTHON3_EXECDIR"] = site_packages
    ENV["PYTHON3_INC"] = python_include

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "-1.30 MEA=21.31", pipe_output("#{bin}/RNAfold --MEA", "CGACGUAGAUGCUAGCUGACUCGAUGC")
    text = "GGGCACCCCCCUUCGGGGGGUCACCUCGCGUAGCUAGCUACGCGAGGGUUAAAGCGCCUUUCUCCCUCGCGUAGC"
    assert_match "-43.30", pipe_output("#{bin}/RNAxplorer -M RSH -n 10 --sequence #{text}")
    system python3, "-c", "import RNA; print(RNA.__doc__)"
    system python3, "-c", "import RNAxplorer"
  end
end

__END__
diff --git a/interfaces/Python/Makefile.am b/interfaces/Python/Makefile.am
--- a/interfaces/Python/Makefile.am
+++ b/interfaces/Python/Makefile.am
@@ -38,11 +38,7 @@ pkgpyexec_DATA = \
 pkgpyexec_DATA = \
     RNA/__init__.py \
     RNA/RNA.py
-pkgpycache_DATA = \
-    RNA/__pycache__/__init__.@PYTHON3_CACHE_TAG@.pyc \
-    RNA/__pycache__/__init__.@PYTHON3_CACHE_OPT1_EXT@ \
-    RNA/__pycache__/RNA.@PYTHON3_CACHE_TAG@.pyc \
-    RNA/__pycache__/RNA.@PYTHON3_CACHE_OPT1_EXT@
+pkgpycache_DATA =

 pkgpyvrnaexecdir = $(py3execdir)/ViennaRNA
 pkgpyvrnaexec_DATA = \
diff --git a/src/RNAxplorer/interfaces/Python/Makefile.am b/src/RNAxplorer/interfaces/Python/Makefile.am
--- a/src/RNAxplorer/interfaces/Python/Makefile.am
+++ b/src/RNAxplorer/interfaces/Python/Makefile.am
@@ -7,8 +7,7 @@ pkgpyexec_DATA =  RNAxplorer/__init__.py

 pkgpyexec_LTLIBRARIES = _RNAxplorer.la
 pkgpyexec_DATA =  RNAxplorer/__init__.py
-pkgpycache_DATA = RNAxplorer/__pycache__/__init__.@PYTHON3_CACHE_TAG@.pyc \
-                  RNAxplorer/__pycache__/__init__.@PYTHON3_CACHE_OPT1_EXT@
+pkgpycache_DATA =

 _RNAxplorer_la_SOURCES = $(INTERFACE_FILES) \
                          $(SWIG_wrapper)