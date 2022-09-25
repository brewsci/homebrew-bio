class Dssp < Formula
  # cite Touw_2015: "https://doi.org/10.1093/nar/gku1028"
  # cite Kabsch_1983: "https://doi.org/10.1002/bip.360221211"
  desc "Assign secondary structure to proteins"
  homepage "https://github.com/PDB-REDO/dssp"
  url "https://github.com/PDB-REDO/dssp/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "1be8a7c4c69a81b34dfacff98499c6a4184f60e1d4f38fe472d37bab57090609"
  license "BSD-2-Clause"
  head "https://github.com/PDB-REDO/dssp.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "35408932044ec98f856214e9d09b05c576f4af0aa281b6028c769ef24da5780d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d9402c5aa18fd3f754e03a4d862ac3271593fbad60875153d9db418f0b4b7e73"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  resource "libcifpp" do
    url "https://github.com/PDB-REDO/libcifpp/archive/refs/tags/v2.0.4.tar.gz"
    sha256 "e31ad85cc6ab1add7aee17be23babd694cbb587d4c0804008541aec72060fd36"
  end

  resource "testdata" do
    url "https://github.com/PDB-REDO/dssp/raw/fa880e3d88f842703f680185fffc4de540284b25/test/1cbs.cif.gz"
    sha256 "c6a2e4716f843bd608c06cfa4b6a369a56a6021ae16e5f876237b8a73d0dcb5e"
  end

  def install
    resource("libcifpp").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath/"libcifpp")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      pkgshare.install Dir[buildpath/"libcifpp/share/libcifpp/*.dic"]
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-Dcifpp_DIR=#{buildpath/"libcifpp/lib/cmake/cifpp"}"
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
