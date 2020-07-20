class Iqtree2 < Formula
  # cite Nguyen_2015: "https://doi.org/10.1093/molbev/msu300"
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  url "https://github.com/Cibiv/IQ-TREE/archive/v2.0.6.tar.gz"
  sha256 "535ca86c7655e68785c5efbfb020006ed7d7de0e2f17e9f31383202ff81f3a85"
  license "GPL-2.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "baafc58a7b075eb6a3b88914232771a64fc0d8a44ca491400c6aec5278691b79" => :catalina
    sha256 "7fa809404cdf7c8749ab0773d55f1d8edd2a46984e19beff9b6c8dc0705b89f0" => :x86_64_linux
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
