class Iqtree < Formula
  # cite Nguyen_2015: "https://doi.org/10.1093/molbev/msu300"
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  url "https://github.com/Cibiv/IQ-TREE/archive/v1.6.5.tar.gz"
  sha256 "1488cec17b2ce1e23dd4367c3a8d43c5d2ed3a965aba61d155034471fbd08154"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "f5014de6c36e33aef433600009e72bd93ba270e4a61fb9931d245885f1e2d75d" => :sierra_or_later
    sha256 "587f038c94b4b68571e08e721266e8fb09a46cf3516b6577104d2170c01d0e6a" => :x86_64_linux
  end

  fails_with :clang # needs openmp

  depends_on "cmake" => :build
  depends_on "eigen" => :build # header only C++ library
  depends_on "gsl"   => :build # static linking
  depends_on "gcc" if OS.mac? # for openmp
  depends_on "zlib" unless OS.mac?

  needs :cxx11

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
