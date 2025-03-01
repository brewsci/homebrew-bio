class SeqanAT3 < Formula
  # cite D_ring_2008: "https://doi.org/10.1186/1471-2105-9-11"
  # cite Reinert_2017: "https://doi.org/10.1016/j.jbiotec.2017.07.017"
  desc "Modern C++ library for sequence analysis"
  homepage "https://www.seqan.de"
  url "https://github.com/seqan/seqan3/releases/download/3.3.0/seqan3-3.3.0-Source.tar.xz"
  sha256 "da2fb621268ebc52b9cc26087e96f4a94109db1f4f28d363d19c7c9cdbd788b1"
  head "https://github.com/seqan/seqan3.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd4fe97e6b8c88bf2cb4c3d66004016862516e2af9a113a8495a6d1210927036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd4fe97e6b8c88bf2cb4c3d66004016862516e2af9a113a8495a6d1210927036"
    sha256 cellar: :any_skip_relocation, ventura:       "fd4fe97e6b8c88bf2cb4c3d66004016862516e2af9a113a8495a6d1210927036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a87ed969bbb46f30ae8fc44699b0d1a737c595d25f7e5d683702f236fe91c994"
  end

  depends_on "cmake" => :build
  depends_on "xz" => :build
  depends_on "gcc@13"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # requires c++20 and concepts
  fails_with :clang do
    cause "seqan3 requires concepts and c++20 support"
  end

  # requires C++20
  fails_with gcc: "4.9"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"
  fails_with gcc: "9"
  fails_with gcc: "10"

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
