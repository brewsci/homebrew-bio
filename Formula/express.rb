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
    sha256 cellar: :any_skip_relocation, mojave:       "1f8d67bf11bf49458dcfa173c13722ab83b6b9a555a2fcc27048f5409d1cdf8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aae8e9f53dc1ea615b5cafa70a954beba40abe40c0fb15026237e42ea6a86529"
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
    inreplace "src/CMakeLists.txt", "libprotobuf.a", "libprotobuf.dylib"
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
