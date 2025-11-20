class Famsa < Formula
  # cite Medema_2011: "https://doi.org/10.1093/nar/gkr466"
  desc "Algorithm for ultra-scale multiple sequence alignments"
  homepage "https://github.com/refresh-bio/FAMSA"
  url "https://github.com/refresh-bio/FAMSA.git",
    tag:      "v2.4.1",
    revision: "45c9b2b4d15e4526212a0e968f130395eef05bb7"
  license "GPL-3.0-or-later"
  head "https://github.com/refresh-bio/FAMSA.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "138555b7705177fcccbfe7ae105af0e2d9ad08cb6e5d28b6b5554b64153901c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb8de904fe2e75f88c051480d473ba0e0d498a71161f1bed27b120c0c850b78e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "177bcd2caedae5e0697091883d5c519f5a2d48b11fdc1724039ab7b5a0493aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6efe4b6e7f7756742f25923629de3249a5ad63b310b7730c9e642addef0990f"
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
    inreplace "makefile", "clanGCC", "llvm_clanGCC" if OS.mac? && DevelopmentTools.clang_build_version <= 1599
    system "gmake"
    bin.install "bin/famsa"
    pkgshare.install "test"
  end

  test do
    system bin/"famsa", share/"famsa/test/adeno_fiber/adeno_fiber", "sl.aln"
    assert_match "-------------LWTTPDT--SPNCR-------IDQDKDSKLSLVLTKCGSQILANVSL", File.read("sl.aln")
  end
end
