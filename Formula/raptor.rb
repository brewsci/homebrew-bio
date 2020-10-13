class Raptor < Formula
  # cite Seiler_2020: "https://doi.org/10.1101/2020.10.08.330985"
  desc "Pre-filter for querying very large collections of nucleotide sequences"
  homepage "https://github.com/seqan/raptor"
  url "https://github.com/seqan/raptor",
    using:    :git,
    tag:      "raptor-v1.0.1",
    revision: "6f2a0cc3cdc05f9311fea0081e644f37772a26bf"
  license "BSD-3-Clause"
  head "https://github.com/seqan/raptor.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "8dde79c5a6b6a79286b02ba145174052dae9124d4b77feddf0546259c1f28d73" => :catalina
    sha256 "31d9b7147732688d898dfa1766a46338fc38652d813c226570bc22a3836f496f" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc@8"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # No C++17 and concepts or C++20 support
  fails_with :clang
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_CXX_FLAGS=-mavx2", *std_cmake_args
    system "make"
    bin.install "bin/raptor"
  end

  test do
    system "raptor", "--version"
    system "raptor", "build", "--help"
    system "raptor", "search", "--help"
  end
end
