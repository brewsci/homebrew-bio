class Percolator < Formula
  # cite K_ll_2007: "https://doi.org/10.1038/nmeth1113"
  desc "Semi-supervised learning for peptide identification from shotgun proteomics data"
  homepage "http://percolator.ms"
  url "https://github.com/percolator/percolator/archive/rel-3-05.tar.gz"
  version "3.05"
  sha256 "5b746bdc0119a40f96bc090e02e27670f91eeb341736911750b170da7e5c06bb"
  license all_of: ["Apache-2.0", "BSD-2-Clause", "BSD-3-Clause", "MIT"]

  depends_on "boost" => :build
  depends_on "cmake" => :build

  def install
    inreplace "CPack.txt", "set(CMAKE_INSTALL_PREFIX /usr/local)", ""
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      Note: This version of percolator does not include XML support.
      To install the full version on Mac OS, consult the official percolator Github
      repository at https://github.com/percolator/percolator
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/percolator --help 2>&1")
  end
end
