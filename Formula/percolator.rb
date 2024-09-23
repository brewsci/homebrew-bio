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
    sha256                               arm64_sonoma: "aaf57f007b6c9ec4a2e66a72c6ccae893b31472d3e8df1cba7c7bea140fbc3be"
    sha256                               ventura:      "1cf29b9f4524b895998a2c938eba562799e45cc9362c02258bb8b6bb5f31d827"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7bbecafa85ca86efdcd5c634ef47a86fa56f00fa1be505061bb3f5642a0b210e"
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
