class Express < Formula
  # cite Roberts_2012: "https://doi.org/10.1038/nmeth.2251"
  desc "Streaming quantification for sequencing"
  homepage "https://pachterlab.github.io/eXpress/"
  url "https://github.com/adarob/eXpress/archive/refs/tags/1.5.3.tar.gz"
  sha256 "1c09fa067672ba2ccbac6901602f3e2d9b5e514ff1fe87f54163e94af69ff022"
  license "Artistic-2.0"
  revision 1
  head "https://github.com/adarob/eXpress.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "7d71881c253d5b192521a74fc6fd7da1d07b4655da3d95515829fc647a21e065"
    sha256 cellar: :any,                 ventura:      "931334a67dbbcb1807e3c9dd0c57d83ba3c2f3208d8c3c8ff62f4b3829af58ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "faae88097c7ba70a8fcbee78005d0761795f09ea6550e25176e20d9a844c1a4d"
  end

  depends_on "bamtools" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gperftools" => :build
  depends_on "abseil"
  depends_on "protobuf"
  uses_from_macos "zlib"

  def install
    # require C++17 for absl and protobuf
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 11)", "set(CMAKE_CXX_STANDARD 17)"
    # use dynamic linking for protobuf
    if OS.mac?
      inreplace "src/CMakeLists.txt", "libprotobuf.a", "libprotobuf.dylib"
    else
      inreplace "src/CMakeLists.txt", "libprotobuf.a", "libprotobuf.so"
    end
    # Use Homebrew's bamtools instead of the vendored copy
    mkdir "bamtools"
    ln_s Formula["bamtools"].include/"bamtools", "bamtools/include"
    ln_s Formula["bamtools"].lib, "bamtools/"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    shell_output("#{bin}/express 2>&1", 1)
  end
end
