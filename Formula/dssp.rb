class Dssp < Formula
  # cite Touw_2015: "https://doi.org/10.1093/nar/gku1028"
  # cite Kabsch_1983: "https://doi.org/10.1002/bip.360221211"
  desc "Assign secondary structure to proteins"
  homepage "https://github.com/PDB-REDO/dssp"
  url "https://github.com/PDB-REDO/dssp/archive/refs/tags/v4.0.5.tar.gz"
  sha256 "759f8fd32c57dfc7c3eed5535d3bc04db13f7de1a5deda8862cebfafcbca84b0"
  license "BSD-2-Clause"
  head "https://github.com/PDB-REDO/dssp.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "07a24bf1799e10c07b891b1bb3d09cc85c85774710c16ad174491099397fbc13"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  resource "libcifpp" do
    url "https://github.com/PDB-REDO/libcifpp/archive/refs/tags/v4.2.2.tar.gz"
    sha256 "458050db52416866033b5557939bc9221bce84f9ffe95cfe1680548db9b2ba39"
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

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-Dcifpp_DIR=#{prefix/"libcifpp/lib/cmake/cifpp"}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("testdata").unpack testpath
    cp Dir[pkgshare/"*.dic"], testpath
    system bin/"mkdssp", "-i", "1cbs.cif", "-o", "test.dssp"
    assert_match "CELLULAR RETINOIC ACID BINDING PROTEIN TYPE II", (testpath/"test.dssp").read
  end
end
