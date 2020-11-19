class SeqanAT3 < Formula
  # cite D_ring_2008: "https://doi.org/10.1186/1471-2105-9-11"
  # cite Reinert_2017: "https://doi.org/10.1016/j.jbiotec.2017.07.017"
  desc "Modern C++ library for sequence analysis"
  homepage "https://www.seqan.de"
  url "https://github.com/seqan/seqan3/releases/download/3.0.2/seqan3-3.0.2-Source.tar.xz"
  sha256 "bab1a9cd0c01fd486842e0fa7a5b41c1bf6d2c43fdadf4c543956923deb62ee9"
  head "https://github.com/seqan/seqan3.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2b09a9199ca88289ae9d7572ea159481e23cb57a419fec0c3e77647179f22a1a" => :catalina
    sha256 "067d5789a5501d6ac6668fc8323cedc0a3cfd0252de6ee2478d754695d0d4f1a" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "xz" => :build
  depends_on "gcc@9"

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
