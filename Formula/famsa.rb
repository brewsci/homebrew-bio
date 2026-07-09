class Famsa < Formula
  # cite Medema_2011: "https://doi.org/10.1093/nar/gkr466"
  desc "Algorithm for ultra-scale multiple sequence alignments"
  homepage "https://github.com/refresh-bio/FAMSA"
  url "https://github.com/refresh-bio/FAMSA.git",
    tag:      "v2.5.2",
    revision: "259841074f86361b50367bed396b4e270dfe343a"
  license "GPL-3.0-or-later"
  head "https://github.com/refresh-bio/FAMSA.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d991c111e24aafc4a04f1384aa272edbcc9c7f7ef2c332629022665290d8bfee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b476ead31f70c5af5b111646e33974e04cec279e2e725edd6a44f9ffd600370"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9b931cf1fb9986d9354d12dc33d6be85207284e59d64a72fb0cec9447f7c1a1"
    sha256 cellar: :any,                 x86_64_linux:  "9c1f8f66720dae03a9ac851a697c6e8f8b0bb42c5537233397dec632c640bf75"
  end

  depends_on "cmake" => :build
  depends_on "make" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1599
  end

  fails_with :clang do
    build 1599
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    inreplace "makefile" do |s|
      s.gsub! "GCC, Darwin_x86_64, 11, 13", "clanGCC, Darwin_x86_64, 11, 20"
      s.gsub! "GCC, Darwin_arm64, 11, 13", "clanGCC, Darwin_arm64, 11, 30"
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
