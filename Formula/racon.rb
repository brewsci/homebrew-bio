class Racon < Formula
  # cite Vaser_2017: "https://doi.org/10.1101/gr.214270.116"
  desc "Compute consensus sequence of a genome assembly of long uncorrected reads"
  homepage "https://github.com/isovic/racon"
  url "https://github.com/isovic/racon/releases/download/1.4.3/racon-v1.4.3.tar.gz"
  sha256 "dfce0bae8234c414ef72b690247701b4299e39a2593bcda548a7a864f51de7f2"
  head "https://github.com/isovic/racon.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "83c39b9ef5b8066098d093346a5c006bbf6fb6787cd7d59c2c5c835d791b3d53" => :mojave
    sha256 "eccd09e43785cf3271996399d4069d807156f847831b2ea76dec89fd2a84f46e" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc" if OS.mac? # for openmp

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/racon --version 2>&1")
    assert_match "usage", shell_output("#{bin}/racon --help")
  end
end
