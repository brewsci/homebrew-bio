class Wtdbg2 < Formula
  desc "Fuzzy de Bruijn Graph long read assembler"
  homepage "https://github.com/ruanjue/wtdbg2"
  url "https://github.com/ruanjue/wtdbg2/archive/v2.5.tar.gz"
  sha256 "a2ffc8503d29f491a9a38ef63230d5b3c96db78377b5d25c91df511d0df06413"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a745e86dde75d8ec852dbd2fbf0c145d921d413274854e69ba1249374275f488"
  end

  depends_on "autoconf" => :build

  # See https://github.com/brewsci/homebrew-bio/pull/504
  depends_on :linux

  uses_from_macos "zlib"

  def install
    system "make"
    system "make", "install", "BIN=#{bin}"
    pkgshare.install "scripts"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wtdbg2 -V 2>&1")
  end
end
