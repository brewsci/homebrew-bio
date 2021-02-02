class Slim < Formula
  # cite Haller_2019: "https://doi.org/10.1093/molbev/msy228"
  desc "Forward simulator for population genetics and evolutionary biology"
  homepage "https://messerlab.org/slim/"
  url "https://github.com/MesserLab/SLiM/archive/v3.5.tar.gz"
  sha256 "7f6f9b33416d0f5a6ab4e004f8f2cb5251b57ae270da7f4b3054b2135765a376"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    mkdir "SLiM_build"
    cd "SLiM_build"
    system "cmake", "-DCMAKE_BUILD_TYPE=Release", "..", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/slim", "-testEidos"
    system "#{bin}/slim", "-testSLiM"
  end
end
