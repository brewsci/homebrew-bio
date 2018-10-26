class Wtdbg2 < Formula
  desc "Fuzzy de Bruijn Graph long read assembler"
  homepage "https://github.com/ruanjue/wtdbg2"
  url "https://github.com/ruanjue/wtdbg2/releases/download/2.1/wtdbg-2.1.tar.bz2"
  sha256 "aff72da1ba9269089d6663e8aaa6d0a35ae7a89f6230a78f60039428274fc61f"

  depends_on "autoconf" => :build

  depends_on :linux # https://github.com/brewsci/homebrew-bio/pull/504

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
