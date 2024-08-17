class Bifrost < Formula
  # cite Holley_2019: "https://doi.org/10.1101/695338"
  desc "Construction, indexing and querying of colored/compacted de Bruijn graphs"
  homepage "https://github.com/pmelsted/bifrost"
  url "https://github.com/pmelsted/bifrost/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "e1b2491328b0cc1a32e433a8a9780f05547fa4b8d674b58abdda9ac8809f5341"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "d4a93e9b4ba5c0704d537f5c7a776dc86525777d1d3b60cc13ffc385568a81b7"
    sha256 cellar: :any,                 ventura:      "c0b75e0e04b6c8231e88d8d515ef0fa2dcefa9ee787defcbed41a657fc001267"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c92a906dd7fafee1211c1a1fe745a5a8395d397a16bf295ed71279964f91c7a7"
  end

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
