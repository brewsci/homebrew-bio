class Slim < Formula
  # cite Haller_2019: "https://doi.org/10.1093/molbev/msy228"
  desc "Forward simulator for population genetics and evolutionary biology"
  homepage "https://messerlab.org/slim/"
  url "https://github.com/MesserLab/SLiM/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "bb63b73e878fb6c15a49f33c3bf1a67047ebb6a11e3d17f930780461dd450400"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "a8edf1645d3aa3644e74926430ec39c6f448dea279e1d6c2791f5b50f4fc83e5"
    sha256 cellar: :any_skip_relocation, ventura:      "bbf271857faa3076dfda21a3d8246f7efad52dbfbe3b280f21cbf4e5f543ac22"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "672addea0a8f042e74793056056150aad2b6525a010681fdbfd97e26d5de5953"
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
