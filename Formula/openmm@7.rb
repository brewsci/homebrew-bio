class OpenmmAT7 < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://openmm.org/"
  url "https://github.com/openmm/openmm/archive/refs/tags/7.7.0.tar.gz"
  sha256 "51970779b8dc639ea192e9c61c67f70189aa294575acb915e14be1670a586c25"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "b59a34726d70c02d7a9f8b68ad5e2c2de91a03b5c49a5ad723fec39eae62ec8e"
    sha256 cellar: :any,                 arm64_sonoma:  "783bf372cc91438b4121ced154274d0eabd6ce58b8db9b6d9239173782689c75"
    sha256 cellar: :any,                 ventura:       "3f6a2a5e07c64ec5ac76a0d12d7d379b92c72278fbf62623c052b97fe0507de3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13e6a8e3feb74ce45619a6d33761f3d8f83d39500495b4b1e9abbc990ba5e14e"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "doxygen" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "swig" => :build
  depends_on "fftw"
  depends_on "openblas"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/5a/25/886e197c97a4b8e254173002cdc141441e878ff29aaa7d9ba560cd6e4866/cython-3.0.12.tar.gz"
    sha256 "b988bb297ce76c671e28c97d017b95411010f7c77fa6623dd0bb47eed1aee1bc"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/65/6e/09db70a523a96d25e115e71cc56a6f9031e7b8cd166c1ac8438307c14058/numpy-1.26.4.tar.gz"
    sha256 "2a02aba9ed12e4ac4eb3ea9421c420301a0c6460d9830d74a9df87efa4912010"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version) # so scripts like `bin/f2py` use newest python
  end

  def install
    inreplace "CMakeLists.txt", "SET CMP0042 OLD", "SET CMP0042 NEW"
    pythons.each do |python|
      python3 = python.opt_libexec/"bin/python"
      venv = virtualenv_create(libexec, python3)
      site_packages = libexec/Language::Python.site_packages(python3)
      venv.pip_install resources.reject { |r| r.name == "numpy" }
      resource("numpy").stage do
        # Use the virtualenv pip to install numpy
        system venv.root/"bin/python", "-m", "pip", "install",
                                       "-Csetup-args=-Dblas=openblas",
                                       "-Csetup-args=-Dlapack=openblas",
                                       *std_pip_args(prefix: false, build_isolation: true),
                                       "--target=#{site_packages}", "."
      end
      # Avoid superenv shim references
      system "cmake", "-S", ".", "-B", "build",
            "-DPYTHON_EXECUTABLE=#{venv.root}/bin/python",
            "-DCMAKE_INSTALL_RPATH=#{rpath}",
            "-DCMAKE_C_COMPILER=#{DevelopmentTools.locate(ENV.cc)}",
            "-DCMAKE_CXX_COMPILER=#{DevelopmentTools.locate(ENV.cxx)}",
            *std_cmake_args
      # Install Python bindings
      cd "build" do
        ENV.prepend_path "PATH", venv.root/"bin"
        ENV.prepend_path "PYTHONPATH", site_packages
        system "make", "install"
        ENV.append "LDFLAGS", "-L#{lib}"
        system "make", "PythonInstall"
      end
      rm_r "build"
    end
  end

  test do
    pythons.each do |python|
      ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python.opt_bin/"python3")
      system libexec/"bin/python", "-m", "openmm.testInstallation"
    end
  end
end
