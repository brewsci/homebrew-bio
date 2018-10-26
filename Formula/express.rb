class Express < Formula
  # cite Roberts_2012: "https://doi.org/10.1038/nmeth.2251"
  desc "Streaming quantification for sequencing"
  homepage "http://bio.math.berkeley.edu/eXpress/"
  url "https://github.com/adarob/eXpress/archive/1.5.2.tar.gz"
  sha256 "831588e4e2c6e60d163bab98a9b4fcf8d2a3fa319cfd33ef0b86cb0af180c66e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "93ec3978d88e6d2aeb087599f4380e3951467492b5627eef3801bf3d86f978a7" => :sierra
    sha256 "8557322f664c213c58e7bbe9de475d160495a9a3fc628eaed3dde4471d25a5c7" => :x86_64_linux
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "bamtools"
  depends_on "gperftools"
  depends_on "protobuf@3.1"
  depends_on "zlib" unless OS.mac?

  def install
    # Reduce parallelism on Circle
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    # Fixes build error on 1.5.2. Remove after next release
    inreplace "src/CMakeLists.txt" do |s|
      s.gsub! "rt", "" if OS.mac?
      s.gsub! "${ZLIB_LIBRARIES} ${BAMTOOLS_LIBRARIES}", "${BAMTOOLS_LIBRARIES} ${ZLIB_LIBRARIES}"
    end

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
