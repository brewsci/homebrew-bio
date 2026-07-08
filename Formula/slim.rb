class Slim < Formula
  # cite Haller_2019: "https://doi.org/10.1093/molbev/msy228"
  desc "Forward simulator for population genetics and evolutionary biology"
  homepage "https://messerlab.org/slim/"
  url "https://github.com/MesserLab/SLiM/archive/refs/tags/v5.2.tar.gz"
  sha256 "ec13f5bcc1784786a556594fa362605cc569b66d3e31838513ab71138df65341"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fe76a1bc0348774d04ce9bb8fba2ec004b57f3d9853d00412e14d7372428a2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "febf313197adf0c130c8c29312b535e5790e0c867f3624ed807f92a004453741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b62212fd91cd581bd834449e3a92ff519cf0b6fa4f1b92caf049061cd9c81a0c"
    sha256 cellar: :any,                 x86_64_linux:  "d30ba7a31f9a770404a60b20ccf55cadf806210287b0fd9b904b85e14c977fef"
  end

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
