class SeqanAT3 < Formula
  # cite D_ring_2008: "https://doi.org/10.1186/1471-2105-9-11"
  # cite Reinert_2017: "https://doi.org/10.1016/j.jbiotec.2017.07.017"
  desc "Modern C++ library for sequence analysis"
  homepage "https://www.seqan.de"
  url "https://github.com/seqan/seqan3/releases/download/3.0.3/seqan3-3.0.3-Source.tar.xz"
  sha256 "42fca82e7e03ba2ed2026be739cd5e0be785152f872fdd0bac13b6f836035fc0"
  head "https://github.com/seqan/seqan3.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "2b09a9199ca88289ae9d7572ea159481e23cb57a419fec0c3e77647179f22a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "067d5789a5501d6ac6668fc8323cedc0a3cfd0252de6ee2478d754695d0d4f1a"
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
