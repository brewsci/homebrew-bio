class Hisat2 < Formula
  include Language::Python::Shebang

  # cite Kim_2015: "https://doi.org/10.1038/nmeth.3317"
  desc "Graph-based alignment to a population of genomes"
  homepage "https://daehwankimlab.github.io/hisat2/"
  url "https://github.com/DaehwanKimLab/hisat2/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "f3f4f867d0a6b1f880d64efc19deaa5788c62050e0a4d614ce98b3492f702599"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/DaehwanKimLab/hisat2.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "2b5b75097703eca1abde911453cf0751395f52d07c7e9d437becd35b8f5b3290"
    sha256 cellar: :any, x86_64_linux: "81d4a8bdf5de5751f06def926c8f7b39b2ee9e1d48905fbe7084cdaa0238f8b1"
  end

  depends_on "python@3.12"

  resource "sse2neon" do
    url "https://raw.githubusercontent.com/DLTcollab/sse2neon/v1.7.0/sse2neon.h"
    sha256 "c36e1355c1a22d9c3357c945d1ef8bd005cb1f0f7b378e6577a45ea96931a083"
  end

  def install
    # Fix compilation error
    # ./VERSION:1:1: error: expected unqualified-id
    rm "VERSION" # VERSION file is not used
    ENV["VERSION"] = version
    # SIMD flag is no longer needed because it is autodetected
    inreplace "Makefile", "-msse2", ""
    # cpuid.h in the third-party directory is not needed
    inreplace "Makefile", "-I third_party", ""
    inreplace "CMakeLists.txt", "include_directories(third_party)", ""
    # use sse2neon for ARM
    if OS.mac? && Hardware::CPU.arm?
      buildpath.install resource("sse2neon")
      inreplace "aligner_sw.h", "#include <emmintrin.h>", "#include \"sse2neon.h\""
      inreplace "sse_util.h", "#include <emmintrin.h>", "#include \"sse2neon.h\""
      inreplace "CMakeLists.txt", " -msse2", "-arch $(shell uname -m)"
    else
      inreplace "CMakeLists.txt", " -msse2", ""
    end
    # POPCNT_CAPABILITY is not supported on ARM
    inreplace "Makefile", "-DPOPCNT_CAPABILITY ", ""
    inreplace "CMakeLists.txt", "-DPOPCNT_CAPABILITY", ""
    # tweaks for processor_support.h
    inreplace "processor_support.h" do |s|
      s.gsub! "#elif defined(__GNUC__)", "#elif defined(__GNUC__) && (defined(__amd64__) || defined(__i386__))"
      s.gsub! 'std::cerr << "ERROR: please define __cpuid() for this build.\n"; ', ""
      s.gsub! "assert(0);", "return false;"
    end
    system "make"
    rm "HISAT2-genotype.png"
    bin.install "hisat2", Dir["hisat2-*"], Dir["hisat2_*.py"]
    bin.find { |f| rewrite_shebang detected_python_shebang, f }
    doc.install Dir["docs/*"]
    pkgshare.install "example", "scripts"
  end

  test do
    system "#{bin}/hisat2-build", "-p", "12", pkgshare/"example/reference/22_20-21M.fa", "genome_index"
    assert_predicate testpath/"genome_index.1.ht2", :exist?
  end
end
