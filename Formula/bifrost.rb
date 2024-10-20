class Bifrost < Formula
  # cite Holley_2019: "https://doi.org/10.1101/695338"
  desc "Construction, indexing and querying of colored/compacted de Bruijn graphs"
  homepage "https://github.com/pmelsted/bifrost"
  url "https://github.com/pmelsted/bifrost/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "e1b2491328b0cc1a32e433a8a9780f05547fa4b8d674b58abdda9ac8809f5341"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "b9a36977af89309d07b6ed0929fa716963e30889208302d6a8d4525b7a631121"
    sha256 cellar: :any,                 arm64_sonoma:  "ec146c60a4f123b8583692cfa3a2d996692aff402621d391d8a6b5c0a26af262"
    sha256 cellar: :any,                 ventura:       "31aa048de60d8051e87b0ba4f786faf66c0bdf287707d68981c9cbcf69f62a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9d024044e58bff7857a76821125cdeece1538c727109d97ab0f8a07280401c"
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
