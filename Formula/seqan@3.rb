class SeqanAT3 < Formula
  # cite D_ring_2008: "https://doi.org/10.1186/1471-2105-9-11"
  # cite Reinert_2017: "https://doi.org/10.1016/j.jbiotec.2017.07.017"
  desc "Modern C++ library for sequence analysis"
  homepage "https://www.seqan.de"
  url "https://github.com/seqan/seqan3/releases/download/3.1.0/seqan3-3.1.0-Source.tar.xz"
  sha256 "0b37b1c3450e19c0ebe42c052c3f87babb8074bd772f10a553949c312c285726"
  head "https://github.com/seqan/seqan3.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "cef50b8157372cb721fc67b8553f1ee95d1e1a786c8c71831268fcdb2c49134a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "05490c38b9c985c4d312ff630cce5a56df585adf2d7f727aadbafd795c79135e"
  end

  depends_on "cmake" => :build
  depends_on "xz" => :build
  depends_on "gcc@9"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # requires c++17 and concepts
  fails_with :clang do
    cause "seqan3 requires concepts and c++17 support"
  end

  fails_with gcc: "4.9" # requires C++17
  fails_with gcc: "5" # requires C++17
  fails_with gcc: "6" # requires C++17

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "SEQAN3_VERSION_MAJOR", File.read(include/"seqan3/version.hpp")
  end
end
