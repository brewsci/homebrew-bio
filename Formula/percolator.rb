class Percolator < Formula
  # cite K_ll_2007: "https://doi.org/10.1038/nmeth1113"
  desc "Semi-supervised learning for peptide identification from shotgun proteomics data"
  homepage "http://percolator.ms"
  url "https://github.com/percolator/percolator/archive/rel-3-05.tar.gz"
  sha256 "5b746bdc0119a40f96bc090e02e27670f91eeb341736911750b170da7e5c06bb"
  license all_of: ["Apache-2.0", "BSD-2-Clause", "BSD-3-Clause", "MIT"]

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "curl"
  depends_on "icu4c"
  depends_on "xerces-c"
  depends_on "xsd"

  def install
    system "cmake", ".", *std_cmake_args, "-DXML_SUPPORT=ON", "-DCMAKE_EXE_LINKER_FLAGS='-licuuc -lcurl'", "-DCMAKE_CXX_FLAGS='-lcurl -std=c++11'"
    system "make", "install"
  end

  test do
    # system "make", "test"
    system "percolator", "-h"
  end
end
