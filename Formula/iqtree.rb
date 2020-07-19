class Iqtree < Formula
  # cite Nguyen_2015: "https://doi.org/10.1093/molbev/msu300"
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  url "https://github.com/Cibiv/IQ-TREE/archive/v1.6.12.tar.gz"
  sha256 "9614092de7a157de82c9cc402b19cc8bfa0cb0ffc93b91817875c2b4bb46a284"
  version_scheme 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "af9c28a20065bd4a0ef289dd1ecb95b3d0050fd164e76712386102333529f02e" => :catalina
    sha256 "0c77422ec0209cfb5ce63f08bf0d06ea065eb79aca488f33cd8bc4d82eee65ac" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build # header only C++ library
  depends_on "gsl"   => :build # static linking
  depends_on "gcc" if OS.mac? # needs openmp

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    if OS.mac?
      inreplace "CMakeLists.txt",
        "${CMAKE_EXE_LINKER_FLAGS_RELEASE} -Wl,--gc-sections",
        "${CMAKE_EXE_LINKER_FLAGS_RELEASE}"
    end

    mkdir "build" do
      system "cmake", "..", "-DIQTREE_FLAGS=omp", *std_cmake_args
      system "make"
    end
    bin.install "build/iqtree"
  end

  test do
    assert_match "boot", shell_output("#{bin}/iqtree 2>&1")
    assert_match version.to_s, shell_output("#{bin}/iqtree -v")
  end
end
