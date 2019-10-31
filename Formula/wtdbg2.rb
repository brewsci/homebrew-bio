class Wtdbg2 < Formula
  desc "Fuzzy de Bruijn Graph long read assembler"
  homepage "https://github.com/ruanjue/wtdbg2"
  url "https://github.com/ruanjue/wtdbg2/archive/v2.5.tar.gz"
  sha256 "a2ffc8503d29f491a9a38ef63230d5b3c96db78377b5d25c91df511d0df06413"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0a9910cf4ff402a2c091589264a3b2236318b6a074cbace3ad16bef9444d39cf" => :x86_64_linux
  end

  depends_on "autoconf" => :build

  uses_from_macos "zlib"

  # See https://github.com/brewsci/homebrew-bio/pull/504
  depends_on :linux

  def install
    system "make"
    system "make", "install", "BIN=#{bin}"
    pkgshare.install "scripts"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wtdbg2 -V 2>&1")
  end
end
