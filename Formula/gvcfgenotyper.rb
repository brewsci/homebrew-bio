class Gvcfgenotyper < Formula
  desc "Merge and genotype Illumina-style gVCFs"
  homepage "https://github.com/Illumina/gvcfgenotyper"
  url "https://github.com/Illumina/gvcfgenotyper/archive/refs/tags/2019.02.26.tar.gz"
  sha256 "9f2e812fa8873aa668514332aa040734d5fbb9321af06451805be559e956cb96"
  license "Apache-2.0"
  head "https://github.com/Illumina/gvcfgenotyper.git", branch: "master"

  depends_on "htslib"

  uses_from_macos "zlib"

  def install
    mkdir "build"
    mkdir "bin"
    # Build against Homebrew's htslib (the bundled htslib is a prebuilt Linux
    # archive; its vendored bcftools code compiles cleanly against modern
    # htslib). Only build the tool, not the gtest-based test binary.
    inreplace "Makefile" do |s|
      s.gsub! "include external/googletest-release-1.8.0//googletest/make/Makefile\n", ""
      s.gsub! "include $(HTSDIR)/htslib.mk\n", ""
      s.gsub! "HTSDIR=external/htslib-1.9", "HTSDIR=#{formula_opt_include("htslib")}"
      s.gsub! "HTSLIB = $(HTSDIR)/libhts.a", "HTSLIB = -L#{formula_opt_lib("htslib")} -lhts"
      s.gsub! "bin/gvcfgenotyper: src/cpp/gvcfgenotyper.cpp  $(OBJS) $(HTSLIB)",
              "bin/gvcfgenotyper: src/cpp/gvcfgenotyper.cpp $(OBJS)"
      # Don't link htslib's transitive libs directly (fails `brew linkage`).
      s.gsub! "LFLAGS = -lz -lm -lpthread -llzma -lbz2", "LFLAGS = -lz -lm -lpthread"
    end

    system "make", "bin/gvcfgenotyper", "CXX=#{ENV.cxx}", "CC=#{ENV.cc}"
    bin.install "bin/gvcfgenotyper"
  end

  test do
    assert_match "GVCF merging and genotyping", shell_output("#{bin}/gvcfgenotyper 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/gvcfgenotyper 2>&1", 1)
  end
end
