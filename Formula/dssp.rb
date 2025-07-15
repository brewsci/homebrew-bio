class Dssp < Formula
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
    rebuild 1
    sha256                               arm64_sequoia: "a314bfdbb32145ce466f543fa4ce9959252cbbf0c3e4b34703616d131db319ee"
    sha256                               arm64_sonoma:  "9e348d1a4fdb10e5a97c50d5e422c77c4694a80b16fd40a431693e5dc80a0c7c"
    sha256                               ventura:       "47d7aa11cb37a31c9031111747268895ba6b0995be4fac85074719d6f21e997e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "367f3a02cc63a02638eb97f378e18ae96f2448777320eb4d620e1913a60bcae9"
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
    ENV.prepend "LDFLAGS", "-undefined dynamic_lookup" if OS.mac?

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

    if OS.mac?
      inreplace "python-module/CMakeLists.txt",
        "target_link_libraries(mkdssp_module dssp::dssp Boost::python ${Python_LIBRARIES})",
        "target_link_libraries(mkdssp_module dssp::dssp Boost::python)"
      inreplace "python-module/CMakeLists.txt",
        'LIBRARY DESTINATION "${Python_SITELIB}"',
        "LIBRARY DESTINATION #{lib}/python3.13/site-packages"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-Dcifpp_DIR=#{prefix/"libcifpp/lib/cmake/cifpp"}",
                    "-Dmcfp_DIR=#{prefix/"libmcfp/lib/cmake/mcfp"}",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DCMAKE_CXX_STANDARD=20",
                    "-DINSTALL_LIBRARY=ON",
                    "-DBUILD_PYTHON_MODULE=ON",
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
