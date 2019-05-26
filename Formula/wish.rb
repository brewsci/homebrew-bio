class Wish < Formula
  desc "Predict prokaryotic host for phage metagenomic sequences"
  homepage "https://github.com/soedinglab/WIsH/"
  url "https://github.com/soedinglab/WIsH/archive/f3cc533aca6d1066e7816740d4d9afae1b3dfd98.tar.gz"
  version "1.0"
  sha256 "379ff91f32c4c1afc546b42688940622b4455ef72b1b411200bd5db02610e165"
  head "https://github.com/soedinglab/WIsH.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0fe6f09eef78b511617714b71dcb5450486e76f56e45fc33ed39a626b37e4ada" => :sierra
    sha256 "0d279486aaffe2c0660a94867bd60d8d102bafd63c8608660cefdf65a854a813" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc" if OS.mac? # OpenMP

  fails_with :clang

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "WIsH"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/WIsH -h")
  end
end
