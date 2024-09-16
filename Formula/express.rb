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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "ac9d63d80441417211f2d996e03b24ea35074847d6a0da72e47490f938b6c609"
    sha256 cellar: :any,                 ventura:      "8b5be34c488b5f49d90e824f3d08fb09243fe6ada6f4cac50bcea84d9039bb70"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2a4c3d451d42587d89b43135cc87f0a39e32b1b59b517f91360e9e402bdef4bc"
  end

  depends_on "bamtools" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gperftools" => :build
  depends_on "abseil"
  depends_on "protobuf"
  uses_from_macos "zlib"

  def install
    # use C++17
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
