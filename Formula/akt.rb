class Akt < Formula
  desc "Ancestry and Kinship Tools for population-scale sequencing data"
  homepage "https://github.com/Illumina/akt"
  url "https://github.com/Illumina/akt/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "1b077dde944cb13132e4fb5b47d4930c1ecfc74b299c95fe3cc7bf5c17b8f710"
  license "GPL-3.0-only"
  head "https://github.com/Illumina/akt.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "70188dad2cb6a18979fae713bed7404479aa2bc46e056a38fbda905d4487bcc9"
    sha256 cellar: :any, arm64_sequoia: "e1d50b63503a38ee707ada9262f9fe3594b44c766734291f6943e35d79a14461"
    sha256 cellar: :any, arm64_sonoma:  "5fd17c4ad5c435f269d0384706b3628602eabc7d5703cd9a58562e848b5752f8"
    sha256 cellar: :any, x86_64_linux:  "0a8351099a8a120fa65855fb150f66ae817abf31fda42d90de9b6b5fffccaedf"
  end

  depends_on "eigen" => :build
  depends_on "htslib"

  uses_from_macos "zlib"

  def install
    eigen = "#{formula_opt_include("eigen")}/eigen3"
    # Build against Homebrew's htslib and a modern Eigen rather than the
    # bundled copies (htslib is a submodule absent from the release tarball;
    # the vendored Eigen predates modern Clang). Eigen 3.4 requires C++14.
    rm_r "Eigen"
    inreplace "Makefile" do |s|
      s.gsub! "include $(HTSDIR)/htslib.mk\n", ""
      s.gsub! "IFLAGS = -I$(HTSDIR)  -I./",
              "IFLAGS = -I#{formula_opt_include("htslib")} -I#{eigen} -I./"
      s.gsub! "HTSLIB = $(HTSDIR)/libhts.a", "HTSLIB = -L#{formula_opt_lib("htslib")} -lhts"
      s.gsub! "akt: akt.cpp version.hh $(OBJS) $(HTSLIB)", "akt: akt.cpp version.hh $(OBJS)"
      s.gsub! "-std=c++11", "-std=c++14"
    end

    # `no_omp` drops -fopenmp and the x86-only -mpopcnt flag.
    system "make", "no_omp", "CXX=#{ENV.cxx}", "CC=#{ENV.cc}"
    bin.install "akt"
  end

  test do
    assert_match "Ancestry and Kinship Tools", shell_output("#{bin}/akt 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/akt 2>&1", 1)
  end
end
