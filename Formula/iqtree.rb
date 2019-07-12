class Iqtree < Formula
  # cite Nguyen_2015: "https://doi.org/10.1093/molbev/msu300"
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  url "https://github.com/Cibiv/IQ-TREE/archive/v1.6.11.tar.gz"
  sha256 "39906e59821b6241fbe2cf5676926ed89a05433a6116322d2d448e1622d9e1c2"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "e4949bf5964090c5c1a9785d86a86cbcd7c3190fe503df08da08c50b5e3bc53b" => :sierra
    sha256 "201e73a51356a687b02de381685b81451f01c9ae24c94fcc146368f0387172d8" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build # header only C++ library
  depends_on "gsl"   => :build # static linking
  depends_on "gcc" if OS.mac? # for openmp
  depends_on "zlib" unless OS.mac?

  fails_with :clang # needs openmp

  def install
    # Reduce memory usage for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

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
