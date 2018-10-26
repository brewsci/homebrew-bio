class Racon < Formula
  # cite Vaser_2017: "https://doi.org/10.1101/gr.214270.116"
  desc "Compute consensus sequence of a genome assembly of long uncorrected reads"
  homepage "https://github.com/isovic/racon"
  url "https://github.com/isovic/racon/releases/download/1.3.1/racon-v1.3.1.tar.gz"
  sha256 "7ce3b1ce6abdb6c6a63d50755b1fc55d5a4d2ab8f86a1df81890d4a7842d9b75"
  head "https://github.com/isovic/racon.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "d3a4cef8fd4caf1679c96d3bbd0ecff41f326322df7d955cce9f5adb61ce0ded" => :sierra
    sha256 "45e64d0b1f886a0b7b47abc002a94bdb83f50e21d719c17292948881bc93ae6e" => :x86_64_linux
  end

  needs :cxx11
  fails_with :clang # needs openmp

  depends_on "cmake" => :build
  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/racon --help")
  end
end
