class Percolator < Formula
  # cite K_ll_2007: "https://doi.org/10.1038/nmeth1113"
  desc "Semi-supervised learning for peptide identification from shotgun proteomics data"
  homepage "http://percolator.ms"
  url "https://github.com/percolator/percolator/archive/rel-3-05.tar.gz"
  sha256 "5b746bdc0119a40f96bc090e02e27670f91eeb341736911750b170da7e5c06bb"
  license :cannot_represent

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on "xerces-c"
  depends_on "xsd"

  def install
    system "cmake", ".", *std_cmake_args, "-D XML_SUPPORT=ON"
    system "make", "install"
  end

  test do
    # system "make", "test"
    system "percolator", "-h"
  end
end
