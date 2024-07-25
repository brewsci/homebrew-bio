class Viennarna < Formula
  # cite Lorenz_2011: "https://doi.org/10.1186/1748-7188-6-26"
  desc "Prediction and comparison of RNA secondary structures"
  homepage "https://www.tbi.univie.ac.at/~ronny/RNA/"
  url "https://github.com/ViennaRNA/ViennaRNA/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "2f9b5ac8a8175b7485ec5e3b773210afce130d6ce0a3b111457c78c4466ad1c7"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "8b6df1b73b8f0df52d391c94fbe27e17838dacc525415a2976a04f4038bbcf53"
    sha256 cellar: :any,                 ventura:      "621dc4aa92b99fb3c0d30fb6377b2d0007b116164398d88ccec2bf442ed92e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "72ddd1730d2d720566c5a59465a9b43dd5aa1834e771db452fd7b8ca4618edbe"
  end

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
  depends_on "perl" # for EXTERN.h
  depends_on "python@3.12"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def python3
    which("python3.12")
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?
    ENV.append "CXXFLAGS", "-std=c++17" # for Kinwalker
    inreplace "src/RNAlocmin/hash_util.h", "register ", "" # c++17 deprecated register

    # regenerate configure file
    system "autoreconf", "-fvi"

    inreplace "src/RNAxplorer/interfaces/Python/Makefile.in",
              "pkgpycache_DATA = RNAxplorer/__pycache__/__init__.@PYTHON3_CACHE_TAG@.pyc \\",
              "pkgpycache_DATA = "
    inreplace "src/RNAxplorer/interfaces/Python/Makefile.in",
              "RNAxplorer/__pycache__/__init__.@PYTHON3_CACHE_OPT1_EXT@",
              ""

    # unpack libsvm and dlib
    cd "src" do
      system "tar", "zxf", "libsvm-3.31.tar.gz"
      system "tar", "jxf", "dlib-19.24.tar.bz2"
    end
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-openmp
      --without-python
      --with-cluster
      --with-kinwalker
      --disable-check-python2
      --prefix=#{prefix}
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
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match "-1.30 MEA=21.31", pipe_output("#{bin}/RNAfold --MEA", "CGACGUAGAUGCUAGCUGACUCGAUGC")
  end
end
