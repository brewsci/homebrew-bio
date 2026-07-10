class Akt < Formula
  desc "Ancestry and Kinship Tools for population-scale sequencing data"
  homepage "https://github.com/Illumina/akt"
  url "https://github.com/Illumina/akt/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "1b077dde944cb13132e4fb5b47d4930c1ecfc74b299c95fe3cc7bf5c17b8f710"
  license "GPL-3.0-only"
  head "https://github.com/Illumina/akt.git", branch: "master"

  depends_on "eigen" => :build
  depends_on "htslib"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "xz"
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
      s.gsub! "LFLAGS = -lz -lm  -lpthread", "LFLAGS = -lz -lm -lpthread -lbz2 -llzma -lcurl"
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
