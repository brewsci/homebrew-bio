class Pugz < Formula
  desc "Truly parallel gzip decompression"
  homepage "https://github.com/Piezoid/pugz"
  url "https://github.com/Piezoid/pugz/archive/recombseq19-demo.tar.gz"
  version "0.8.0"
  sha256 "1005519d7ea80c4f59593b0e9bd2e9337c02a2b5c52dfe1732c16f75e4eeecb3"

  depends_on "gcc" if OS.mac? # for openmp

  fails_with :clang # needs openmp

  def install
    # https://github.com/Piezoid/pugz/issues/10
    inreplace "Makefile", "-lrt", "-lpthread -lrt"

    system "make", "V=1"
    bin.install "gunzip" => "pugz"
    pkgshare.install "example"
    doc.install "paper/paper.pdf"
  end

  test do
    assert_match "Chikhi", shell_output("#{bin}/pugz -V 2>&1")
  end
end
