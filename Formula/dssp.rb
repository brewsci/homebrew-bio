class Dssp < Formula
  # cite Touw_2015: "https://doi.org/10.1093/nar/gku1028"
  # cite Kabsch_1983: "https://doi.org/10.1002/bip.360221211"
  desc "Assign secondary structure to proteins"
  homepage "https://github.com/PDB-REDO/dssp"
  url "https://github.com/PDB-REDO/dssp/archive/refs/tags/v4.5.8.tar.gz"
  sha256 "634bf8d8dd96954bd680da90f3dcb66b87189c13b12b52b61de8af9d597b74ac"
  license "BSD-2-Clause"
  head "https://github.com/PDB-REDO/dssp.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_tahoe:   "d45475bf8199829d609582e258ba69750065d030b79cb4a113b84d7526a017e0"
    sha256 arm64_sequoia: "d0be878aba733d32d7edca8c60c65cc56e1943881cf618e0b5cca024d65f29bf"
    sha256 arm64_sonoma:  "d24532334598a6c11f5d55cff4d38763d03ad4d2b9251c5ef3d4329111b4836b"
    sha256 x86_64_linux:  "1a470214991f93d6121ad1b23c1126fa6b782dec19576b685b18eab4aeb75c4f"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "icu4c"
  depends_on "pcre2"
  depends_on "python@3.14"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "gcc" => :build # for C++20 support
    depends_on "fmt"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "12"
    cause "requires GCC 13+"
  end

  resource "libcifpp" do
    url "https://github.com/PDB-REDO/libcifpp/archive/refs/tags/v9.0.6.tar.gz"
    sha256 "e6263a63404762671d6875de385e0c7ad869b0fe3fae41808003e00c94e7ed8c"
  end

  resource "libmcfp" do
    url "https://github.com/mhekkel/libmcfp/archive/refs/tags/v2.0.0.tar.gz"
    sha256 "696d1fc1b8280ccc51af311458596220a20865b5fd1402a0f719120b5b4fd2a2"
  end

  resource "homebrew-testdata" do
    url "https://github.com/PDB-REDO/dssp/raw/fa880e3d88f842703f680185fffc4de540284b25/test/1cbs.cif.gz"
    sha256 "c6a2e4716f843bd608c06cfa4b6a369a56a6021ae16e5f876237b8a73d0dcb5e"
  end

  def python3
    "python3.14"
  end

  def install
    ENV.append "CXXFLAGS", "-std=c++20"
    resource("libcifpp").stage do
      # libcifpp should be installed in 'prefix' directory since the path of dic files are always required.
      system "cmake", "-S", ".", "-B", "build",
             "-DCMAKE_CXX_STANDARD=20",
             *std_cmake_args(install_prefix: prefix/"libcifpp")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("libmcfp").stage do
      # libmcfp should be installed in 'prefix' directory since the path of dic files are always required.
      if OS.mac? && MacOS.version <= :sequoia
        inreplace "CMakeLists.txt" do |s|
          s.gsub! "if(NOT STD_CHARCONV_COMPILING)\n\tmessage",
                  "find_package(FastFloat 8.0 QUIET CONFIG)\nif(STD_CHARCONV_COMPILING)\n\tmessage"
          s.gsub! "PRIVATE $<TARGET_PROPERTY:FastFloat::fast_float,INTERFACE_INCLUDE_DIRECTORIES>",
                  "PRIVATE FastFloat::fast_float"
        end
      end
      system "cmake", "-S", ".", "-B", "build",
             "-DCMAKE_CXX_STANDARD=20",
             *std_cmake_args(install_prefix: prefix/"libmcfp")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    inreplace "python-module/CMakeLists.txt",
      'LIBRARY DESTINATION "${Python_SITELIB}"',
      "LIBRARY DESTINATION #{prefix/Language::Python.site_packages(python3)}"

    inreplace "python-module/CMakeLists.txt",
              "Boost::python ${Python_LIBRARIES}",
              "Boost::python -Wl,-undefined,dynamic_lookup,-rpath,#{prefix/Language::Python.site_packages(python3)/"dssp"}"

    if OS.mac? && MacOS.version <= :sequoia
      inreplace "CMakeLists.txt",
                "find_package(mrc QUIET)",
                "find_package(mrc QUIET)\nfind_package(FastFloat 8.0 QUIET CONFIG)"
    end
    system "cmake", "-S", ".", "-B", "build",
                    "-Dcifpp_DIR=#{prefix/"libcifpp/lib/cmake/cifpp"}",
                    "-Dmcfp_DIR=#{prefix/"libmcfp/lib/cmake/mcfp"}",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DBUILD_PYTHON_MODULE=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-testdata").unpack testpath
    cp Dir[pkgshare/"*.dic"], testpath
    system bin/"mkdssp", "1cbs.cif", "test.dssp"
    assert_match "CELLULAR RETINOIC ACID BINDING PROTEIN TYPE II", (testpath/"test.dssp").read

    (testpath/"test.py").write <<~EOS
      import os

      from mkdssp import dssp

      file_path = os.path.join("1cbs.cif")

      with open(file_path, "r") as f:
          file_content = f.read()

      dssp = dssp(file_content)
      print("residues: ", dssp.statistics.residues)
      for res in dssp:
          print(res.asym_id, res.seq_id, res.compound_id, res.type)
    EOS
    output = shell_output("#{python3} test.py")
    assert_match "residues:  137", output
    assert_match "A 1 PRO Loop", output
  end
end
