class Dssp < Formula
  # cite Touw_2015: "https://doi.org/10.1093/nar/gku1028"
  # cite Kabsch_1983: "https://doi.org/10.1002/bip.360221211"
  desc "Assign secondary structure to proteins"
  homepage "https://github.com/PDB-REDO/dssp"
  url "https://github.com/PDB-REDO/dssp/archive/refs/tags/v4.4.10.tar.gz"
  sha256 "b535d0410a79d612a2abea308d13d0ae2645bb925b13a86e5bb53c38b0fac723"
  license "BSD-2-Clause"
  head "https://github.com/PDB-REDO/dssp.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sequoia: "0d21ff263d560dc08096567a39c6ae45582766ace2f6a0fff32fa0c5f31efead"
    sha256 arm64_sonoma:  "96e87525fdfedbb8669e52e74acdd9ae892703acde5a926df4d5ae8b9f199e3f"
    sha256 ventura:       "a1beeb06564ff9f4554588ece5380ec3617aea9932e9f11db4cf2478d8ac591e"
    sha256 x86_64_linux:  "0e13b1a6312ef61247e557a110fbdec60171ad56e769a4139d8d6a01f3056a55"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "boost"
  depends_on "icu4c"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  resource "libcifpp" do
    url "https://github.com/PDB-REDO/libcifpp/archive/refs/tags/v7.0.7.tar.gz"
    sha256 "0e88805b4704d4a899aeee6df5aaace1d6b47d8ccb3a3f39b35bc5a3997c09ac"
  end

  resource "libmcfp" do
    url "https://github.com/mhekkel/libmcfp/archive/refs/tags/v1.3.3.tar.gz"
    sha256 "d35e83e660c3cb443d20246fea39e78d2a11faebe3205ab838614f0280c308d0"
  end

  resource "testdata" do
    url "https://github.com/PDB-REDO/dssp/raw/fa880e3d88f842703f680185fffc4de540284b25/test/1cbs.cif.gz"
    sha256 "c6a2e4716f843bd608c06cfa4b6a369a56a6021ae16e5f876237b8a73d0dcb5e"
  end

  def install
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

    system "cmake", "-S", ".", "-B", "build",
                    "-Dcifpp_DIR=#{prefix/"libcifpp/lib/cmake/cifpp"}",
                    "-Dlibmcfp_DIR=#{prefix/"libmcfp/lib/cmake/libmcfp"}",
                    "-DCMAKE_BUILD_TYPE=Release",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("testdata").unpack testpath
    cp Dir[pkgshare/"*.dic"], testpath
    system bin/"mkdssp", "1cbs.cif", "test.dssp"
    assert_match "CELLULAR RETINOIC ACID BINDING PROTEIN TYPE II", (testpath/"test.dssp").read
  end
end
