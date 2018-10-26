class Wtdbg2 < Formula
  desc "Fuzzy de Bruijn Graph long read assembler"
  homepage "https://github.com/ruanjue/wtdbg2"
  url "https://github.com/ruanjue/wtdbg2/releases/download/2.1/wtdbg-2.1.tar.bz2"
  sha256 "aff72da1ba9269089d6663e8aaa6d0a35ae7a89f6230a78f60039428274fc61f"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "632f04d7df45eeb45270bafbbdf7e2a896f82bc71ee76ae558c1c47541e5cbbd" => :x86_64_linux
  end

  depends_on "autoconf" => :build

  # See https://github.com/brewsci/homebrew-bio/pull/504
  depends_on :linux

  def install
    # https://github.com/ruanjue/wtdbg2/issues/30
    bin.mkpath

    # https://github.com/ruanjue/wtdbg2/issues/31
    inreplace "mem_share.h", "endian.h", "machine/endian.h" if OS.mac?

    system "make"
    system "make", "install", "BIN=#{bin}"
    pkgshare.install "scripts"
  end

  test do
    # https://github.com/ruanjue/wtdbg2/issues/29
    assert_match version.to_s, shell_output("#{bin}/wtdbg2 -h 2>&1", 1)
  end
end
