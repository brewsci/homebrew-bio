class Slim < Formula
  # cite Haller_2019: "https://doi.org/10.1093/molbev/msy228"
  desc "Forward simulator for population genetics and evolutionary biology"
  homepage "https://messerlab.org/slim/"
  url "https://github.com/MesserLab/SLiM/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "bb63b73e878fb6c15a49f33c3bf1a67047ebb6a11e3d17f930780461dd450400"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "f33ea710cb58c11264d0dd99598076466d5b3933c631de0a59be0650e1046f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "03a4ae3d6ab3dd077833d196938cb9f1fe0258b102f2c3f800b7f326993ef0d0"
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
