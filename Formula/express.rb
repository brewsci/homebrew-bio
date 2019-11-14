class Express < Formula
  # cite Roberts_2012: "https://doi.org/10.1038/nmeth.2251"
  desc "Streaming quantification for sequencing"
  homepage "http://bio.math.berkeley.edu/eXpress/"
  url "https://github.com/adarob/eXpress/archive/1.5.3.tar.gz"
  sha256 "1c09fa067672ba2ccbac6901602f3e2d9b5e514ff1fe87f54163e94af69ff022"
  head "https://github.com/adarob/eXpress.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "93ec3978d88e6d2aeb087599f4380e3951467492b5627eef3801bf3d86f978a7" => :sierra
    sha256 "8557322f664c213c58e7bbe9de475d160495a9a3fc628eaed3dde4471d25a5c7" => :x86_64_linux
  end

  depends_on "bamtools" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gperftools" => :build
  depends_on "protobuf" => :build
  uses_from_macos "zlib"

  def install
    # Reduce parallelism on Circle
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    # Use Homebrew's bamtools instead of the vendored copy
    mkdir "bamtools"
    ln_s Formula["bamtools"].include/"bamtools", "bamtools/include"
    ln_s Formula["bamtools"].lib, "bamtools/"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    shell_output("#{bin}/express 2>&1", 1)
  end
end
