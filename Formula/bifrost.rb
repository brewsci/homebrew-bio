class Bifrost < Formula
  # cite Holley_2019: "https://doi.org/10.1101/695338"
  desc "Construction, indexing and querying of colored/compacted de Bruijn graphs"
  homepage "https://github.com/pmelsted/bifrost"
  url "https://github.com/pmelsted/bifrost/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "e1b2491328b0cc1a32e433a8a9780f05547fa4b8d674b58abdda9ac8809f5341"
  license "BSD-2-Clause"

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  def install
    args = std_cmake_args + %W[
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
