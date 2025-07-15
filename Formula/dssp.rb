class Dssp < Formula
  include Language::Python::Virtualenv

  # cite Touw_2015: "https://doi.org/10.1093/nar/gku1028"
  # cite Kabsch_1983: "https://doi.org/10.1002/bip.360221211"
  desc "Assign secondary structure to proteins"
  homepage "https://github.com/PDB-REDO/dssp"
  url "https://github.com/PDB-REDO/dssp/archive/refs/tags/v4.5.3.tar.gz"
  sha256 "8dd92fdf2a252a170c8a811e3adb752e0f2860318ecb2b6ed5e4fd1d2b5ce5e6"
  license "BSD-2-Clause"
  head "https://github.com/PDB-REDO/dssp.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256                               arm64_sequoia: "55f0253111a3e79cff8f7653d52d7c5295f3138a9a0b20f268b6a018bdbb1d3a"
    sha256                               arm64_sonoma:  "e7bef1832790c59eeabe4890593c5ef8479fb27d587d3999e185ff88ac806ed5"
    sha256                               ventura:       "b79db046768440cd02d376f23715af7774adbf30f86a92ffefd403f20afec59f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a5e2a87fe009c067b28589591c25b3405b303ac1c243b49bc968961dc53524"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "icu4c"
  depends_on "python@3.13"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  resource "libcifpp" do
    url "https://github.com/PDB-REDO/libcifpp/archive/refs/tags/v8.0.1.tar.gz"
    sha256 "53f0ff205711428dcabf9451b23804091539303cea9d2f54554199144ca0fc4e"
  end

  resource "libmcfp" do
    url "https://github.com/mhekkel/libmcfp/archive/refs/tags/v1.4.2.tar.gz"
    sha256 "dcdf3e81601081b2a9e2f2e1bb1ee2a8545190358d5d9bec9158ad70f5ca355e"
  end

  resource "testdata" do
    url "https://github.com/PDB-REDO/dssp/raw/fa880e3d88f842703f680185fffc4de540284b25/test/1cbs.cif.gz"
    sha256 "c6a2e4716f843bd608c06cfa4b6a369a56a6021ae16e5f876237b8a73d0dcb5e"
  end

  def python3
    "python3.13"
  end

  def install
    if OS.mac?
      ENV.prepend "LDFLAGS", "-undefined dynamic_lookup"
    end

    resource("libcifpp").stage do
      # libcifpp should be installed in 'prefix' directory since the path of dic files are always required.
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: prefix/"libcifpp")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("libmcfp").stage do
      # libcifpp should be installed in 'prefix' directory since the path of dic files are always required.
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: prefix/"libmcfp")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    venv = virtualenv_create libexec, which(python3)
    ENV.prepend_path "PATH", libexec/"bin"
    ENV.prepend_create_path "PYTHONPATH", venv.site_packages
    site_packages_path = Language::Python.site_packages python3
    (prefix/site_packages_path/"homebrew-dssp.pth").write venv.site_packages
    shared_lib_ext = OS.mac? ? "dylib" : "so"

    system "cmake", "-S", ".", "-B", "build",
                    "-Dcifpp_DIR=#{prefix/"libcifpp/lib/cmake/cifpp"}",
                    "-Dmcfp_DIR=#{prefix/"libmcfp/lib/cmake/mcfp"}",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DCMAKE_CXX_STANDARD=20",
                    "-DINSTALL_LIBRARY=ON",
                    "-DBUILD_PYTHON_MODULE=ON",
                    "-DPython_ROOT_DIR=#{libexec}",
                    "-DPython_EXECUTABLE=#{libexec/"bin/python3.13"}",
                    "-DPython_INCLUDE_DIR=#{libexec/"include/python3.13"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("testdata").unpack testpath
    cp Dir[pkgshare/"*.dic"], testpath
    system bin/"mkdssp", "1cbs.cif", "test.dssp"
    assert_match "CELLULAR RETINOIC ACID BINDING PROTEIN TYPE II", (testpath/"test.dssp").read

    # Check if the Python module can be imported
    system python3, "-c", "import mkdssp"
  end
end
