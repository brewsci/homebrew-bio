class Express < Formula
  # cite Roberts_2012: "https://doi.org/10.1038/nmeth.2251"
  desc "Streaming quantification for sequencing"
  homepage "http://bio.math.berkeley.edu/eXpress/"
  url "https://github.com/adarob/eXpress/archive/1.5.3.tar.gz"
  sha256 "1c09fa067672ba2ccbac6901602f3e2d9b5e514ff1fe87f54163e94af69ff022"
  head "https://github.com/adarob/eXpress.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "1f8d67bf11bf49458dcfa173c13722ab83b6b9a555a2fcc27048f5409d1cdf8b" => :mojave
    sha256 "aae8e9f53dc1ea615b5cafa70a954beba40abe40c0fb15026237e42ea6a86529" => :x86_64_linux
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
