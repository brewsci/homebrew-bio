class Famsa < Formula
  # cite Medema_2011: "https://doi.org/10.1093/nar/gkr466"
  desc "Algorithm for ultra-scale multiple sequence alignments"
  homepage "https://github.com/refresh-bio/FAMSA"
  url "https://github.com/refresh-bio/FAMSA.git",
    tag:      "v2.4.1",
    revision: "45c9b2b4d15e4526212a0e968f130395eef05bb7"
  license "GPL-3.0-or-later"
  head "https://github.com/refresh-bio/FAMSA.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "make" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    # Ventura seems to be missing the `source_location` header.
    depends_on "llvm" => :build
  end

  fails_with :clang do
    build 1499
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    ENV.append "CXXFLAGS", "-std=c++20" if OS.mac?
    inreplace "makefile" do |s|
      s.gsub! "GCC, Darwin_x86_64, 11, 13", "clanGCC, Darwin_x86_64, 11, 20"
      s.gsub! "GCC, Darwin_arm64, 11, 13", "clanGCC, Darwin_arm64, 11, 20"
    end
    system "gmake"
    bin.install "bin/famsa"
    pkgshare.install "test"
  end

  test do
    system bin/"famsa", share/"famsa/test/adeno_fiber/adeno_fiber", "sl.aln"
    assert_match "-------------LWTTPDT--SPNCR-------IDQDKDSKLSLVLTKCGSQILANVSL", File.read("sl.aln")
  end
end
