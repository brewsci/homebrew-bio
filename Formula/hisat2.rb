class Hisat2 < Formula
  include Language::Python::Shebang

  # cite Kim_2015: "https://doi.org/10.1038/nmeth.3317"
  desc "Graph-based alignment to a population of genomes"
  homepage "https://daehwankimlab.github.io/hisat2/"
  url "https://github.com/DaehwanKimLab/hisat2/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "d3996d7bee30e38e51beb69c44b10461a4692e686487c465f9a20e3f54b6e815"
  license "GPL-3.0-or-later"
  head "https://github.com/DaehwanKimLab/hisat2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9fe862014d2d534f994c0fec85985f31b983bf3860753446c3d8de36229d4a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acfe20f863cd0d02920e030726a4c3c2069d33d7473e3fea8941c2447aa3d0c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c160c22e90799693a2a9a226dc8093bea30f5b335e8858cc952120685504591c"
    sha256 cellar: :any,                 x86_64_linux:  "e637568676afa7f851a9710af945c333a9446a464cb5f2060ae0e39c4fba300a"
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
    system bin/"hisat2-build", "-p", "12", pkgshare/"example/reference/22_20-21M.fa", "genome_index"
    assert_path_exists testpath/"genome_index.1.ht2"
  end
end
