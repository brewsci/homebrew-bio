class Raptor < Formula
  # cite Seiler_2021: "https://doi.org/10.1016/j.isci.2021.102782"
  desc "Pre-filter for querying very large collections of nucleotide sequences"
  homepage "https://github.com/seqan/raptor"
  url "https://github.com/seqan/raptor",
    using:    :git,
    tag:      "raptor-v2.0.0",
    revision: "12c6b50d772de709fc265d2bd15bfa3b267cd18c"
  license "BSD-3-Clause"
  head "https://github.com/seqan/raptor.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "def1790f20a7e914f8759d0168abefa8dbf8bb637a46e4abbbb8023aa7b453eb"
    sha256               x86_64_linux: "4e8e33bfdaadf1621ea46807d3c4b9245ff734b6b3d71ab2e16c406b252fa5dd"
  end

  depends_on "cmake" => :build
  depends_on "gcc@9"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Requires gcc>=9, clang does not yet work.
  fails_with :clang
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"

  def install
    system "cmake", ".",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DCMAKE_CXX_FLAGS=-mavx2",
           "-DRAPTOR_NATIVE_BUILD=OFF",
           *std_cmake_args
    system "make"
    bin.install "bin/raptor"
  end

  test do
    system "raptor", "--version"
    system "raptor", "build", "--help"
    system "raptor", "search", "--help"
  end
end
