class Dssp < Formula
  # cite Touw_2015: "https://doi.org/10.1093/nar/gku1028"
  # cite Kabsch_1983: "https://doi.org/10.1002/bip.360221211"
  desc "Assign secondary structure to proteins"
  homepage "https://github.com/PDB-REDO/dssp"
  url "https://github.com/PDB-REDO/dssp/archive/refs/tags/v4.5.6.tar.gz"
  sha256 "940062a5c97be30546af045020761dbba68d4ca64cbaf2343b3765c0bf1f10b3"
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
  depends_on "libmcfp" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "icu4c"
  depends_on "libcifpp"
  depends_on "pcre2"
  depends_on "python3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  resource "testdata" do
    url "https://github.com/PDB-REDO/dssp/raw/fa880e3d88f842703f680185fffc4de540284b25/test/1cbs.cif.gz"
    sha256 "c6a2e4716f843bd608c06cfa4b6a369a56a6021ae16e5f876237b8a73d0dcb5e"
  end

  def install
    ENV.append "CXXFLAGS", "-O3"
    ENV.prepend "LDFLAGS", "-undefined dynamic_lookup" if OS.mac?

    py_ver = Language::Python.major_minor_version "python3"
    site_packages = lib/"python#{py_ver}/site-packages"
    mkdir_p site_packages

    if OS.mac?
      inreplace "python-module/CMakeLists.txt",
        "target_link_libraries(mkdssp_module dssp::dssp Boost::python ${Python_LIBRARIES})",
        "target_link_libraries(mkdssp_module dssp::dssp Boost::python)"
      inreplace "python-module/CMakeLists.txt",
        'LIBRARY DESTINATION "${Python_SITELIB}"',
        "LIBRARY DESTINATION #{site_packages}"
    end

    inreplace "libdssp/CMakeLists.txt",
      "DESTINATION share/libcifpp",
      "DESTINATION #{pkgshare}"

    inreplace "CMakeLists.txt", "${CIFPP_SHARE_DIR}", pkgshare

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DCMAKE_CXX_STANDARD=20",
                    "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}",
                    "-DINSTALL_LIBRARY=ON",
                    "-DBUILD_PYTHON_MODULE=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    # Move files that could not be installed in libcifpp's share/ due to permission issues
    system "ls", "-l", pkgshare
    mv Dir["#{pkgshare}/*"], Formula["libcifpp"].pkgshare
  end

  test do
    resource("testdata").unpack testpath
    system bin/"mkdssp", "1cbs.cif", "test.dssp"
    assert_match "CELLULAR RETINOIC ACID BINDING PROTEIN TYPE II", (testpath/"test.dssp").read

    # Check if the Python module can be imported
    system "python3", "-c", "import mkdssp"
  end
end
