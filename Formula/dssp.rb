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
    sha256 arm64_tahoe:   "a574887c62903f6585d7697ee002edd38d4394b1ec38671f401e4c483f6286e6"
    sha256 arm64_sequoia: "1ce24fc49172fbf6369dd0da24e3b10b39873bf6858dd5c169e6708efd2f8cc8"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "icu4c"
  depends_on "pcre2"
  depends_on "python@3.14"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  resource "libcifpp" do
    url "https://github.com/PDB-REDO/libcifpp/archive/refs/tags/v9.0.3.tar.gz"
    sha256 "f4f359d77c4e29b95a7d3a85658c783022def8f70a9bb94a9da47111f45f5edd"
  end

  resource "libmcfp" do
    url "https://github.com/mhekkel/libmcfp/archive/refs/tags/v1.4.2.tar.gz"
    sha256 "dcdf3e81601081b2a9e2f2e1bb1ee2a8545190358d5d9bec9158ad70f5ca355e"
  end

  resource "homebrew-testdata" do
    url "https://github.com/PDB-REDO/dssp/raw/fa880e3d88f842703f680185fffc4de540284b25/test/1cbs.cif.gz"
    sha256 "c6a2e4716f843bd608c06cfa4b6a369a56a6021ae16e5f876237b8a73d0dcb5e"
  end

  def python3
    "python3.14"
  end

  def install
    ENV["CXXFLAGS"] = "#{ENV["CXXFLAGS"]} -std=c++20"
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
      system "cmake", "-S", ".", "-B", "build",
             "-DCMAKE_CXX_STANDARD=20",
             *std_cmake_args(install_prefix: prefix/"libmcfp")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    inreplace "python-module/CMakeLists.txt",
      'LIBRARY DESTINATION "${Python_SITELIB}"',
      "LIBRARY DESTINATION #{prefix/Language::Python.site_packages(python3)}"

    dssp_rpath = rpath(source: prefix/Language::Python.site_packages(python3)/"dssp")
    inreplace "python-module/CMakeLists.txt", "${Python_LIBRARIES}",
                                              "-Wl,-undefined,dynamic_lookup,-rpath,#{dssp_rpath}"

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
