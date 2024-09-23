class Percolator < Formula
  # cite K_ll_2007: "https://doi.org/10.1038/nmeth1113"
  desc "Semi-supervised learning for peptide identification from shotgun proteomics data"
  homepage "https://github.com/percolator/percolator"
  url "https://github.com/percolator/percolator/archive/refs/tags/rel-3-07-01.tar.gz"
  version "3.7.1"
  sha256 "f1c9833063cb4e99c51a632efc3f80c6b8f48a43fd440ea3eb0968af5c84b97a"
  license all_of: ["Apache-2.0", "BSD-2-Clause", "BSD-3-Clause", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 catalina:     "9946c885c0596ffdb1ddcd73ec4f9e93e780c87ab1a891541753f5cae22f3d09"
    sha256 x86_64_linux: "4b1a53dd1bed88db9b43b9ecf83cd708aa7704b7a4e77b7ec0a10d76c7f59d2a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build

  def install
    inreplace "CPack.txt", "set(CMAKE_INSTALL_PREFIX /usr/local)", ""
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
