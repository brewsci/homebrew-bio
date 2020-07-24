class Iqtree2 < Formula
  # cite Nguyen_2015: "https://doi.org/10.1093/molbev/msu300"
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  url "https://github.com/Cibiv/IQ-TREE/archive/v2.0.7.tar.gz"
  sha256 "e0c00c040c9dd448aa15b8e17964a414b86eaeb024bef0b13767fe0c68730ae5"
  license "GPL-2.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "b9d0f98622e3223771bbdd6c86861a37d240dfa9bdc357888b589802b0eb8056" => :catalina
    sha256 "06d8c6b11ddb0b991ed2b1e237a4c900be94a632dc4ba4deb442a241dbf4f996" => :x86_64_linux
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build # header only C++ library
  depends_on "gsl"   => :build # static linking
  depends_on "gcc" if OS.mac? # needs openmp

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    # Should be fixed in 2.0.8
    inreplace "CMakeLists.txt", "--target=x86_64-apple-macos10.7", "-mmacosx-version-min=10.7"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "boot", shell_output("#{bin}/iqtree2 -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/iqtree2 --version")
  end
end
