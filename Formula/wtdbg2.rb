class Wtdbg2 < Formula
  desc "Fuzzy de Bruijn Graph long read assembler"
  homepage "https://github.com/ruanjue/wtdbg2"
  url "https://github.com/ruanjue/wtdbg2/archive/v2.4.tar.gz"
  sha256 "64f0a9d76f421d2311e91ba1aa4f12d4fb11d188a2804b01278121ee2e40d9a0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0a9910cf4ff402a2c091589264a3b2236318b6a074cbace3ad16bef9444d39cf" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  depends_on "autoconf" => :build

  # See https://github.com/brewsci/homebrew-bio/pull/504
  depends_on :linux

  def install
    # https://github.com/ruanjue/wtdbg2/issues/31
    inreplace "mem_share.h", "endian.h", "machine/endian.h" if OS.mac?

    system "make"
    system "make", "install", "BIN=#{bin}"
    pkgshare.install "scripts"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wtdbg2 -h 2>&1")
  end
end
