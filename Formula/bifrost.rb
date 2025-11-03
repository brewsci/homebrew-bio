class Bifrost < Formula
  # cite Holley_2019: "https://doi.org/10.1101/695338"
  desc "Construction, indexing and querying of colored/compacted de Bruijn graphs"
  homepage "https://github.com/pmelsted/bifrost"
  url "https://github.com/pmelsted/bifrost/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "e1b2491328b0cc1a32e433a8a9780f05547fa4b8d674b58abdda9ac8809f5341"
  license "BSD-2-Clause"

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  patch do
    url "https://raw.githubusercontent.com/bioconda/bioconda-recipes/8ef9d93d31ff5bea8e6b4f996e4f748670957125/recipes/bifrost/0001-master.patch"
    sha256 "e7dad0ca7fd610b8429fcdb93c4d5f24e9693438b726d89925494e5d967d74e0"
  end

  def install
    args = std_cmake_args + %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DMAX_KMER_SIZE=64
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/Bifrost --version 2>&1")
  end
end
