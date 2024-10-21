class Slim < Formula
  # cite Haller_2019: "https://doi.org/10.1093/molbev/msy228"
  desc "Forward simulator for population genetics and evolutionary biology"
  homepage "https://messerlab.org/slim/"
  url "https://github.com/MesserLab/SLiM/archive/refs/tags/v4.3.tar.gz"
  sha256 "b390a6638a915d6f955608610bca6e94fc0f4d62f5ad07376b2aa98756e8c81d"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/slim", "-testEidos"
    system "#{bin}/slim", "-testSLiM"
  end
end
