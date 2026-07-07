class Gfakluge < Formula
  # cite Dawson_2019: "https://doi.org/10.21105/joss.01083"
  desc "C++ library and utilities for Graphical Fragment Assembly (GFA)"
  homepage "https://github.com/edawson/gfakluge"
  url "https://github.com/edawson/gfakluge/archive/refs/tags/1.1.3.tar.gz"
  sha256 "64aa19d95d3ae439315bc032645c6b4519cf93e67b60910ea9cef24695d00d0a"
  license "MIT"
  head "https://github.com/edawson/gfakluge.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "977ebe86eb2dfe0ae4ee25fdfaaf65dd3f14f2c194f940ecf0c2b4d6268d23e7"
    sha256 cellar: :any, x86_64_linux: "109b9d58544ef9e80d7a49a4067e5ff8ae04d79e2d35abeade3c82f83f2446ef"
  end

  depends_on "gcc" if OS.mac? # needs openmp

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    inreplace "Makefile", "  mkdir -p $(DESTDIR)$(PREFIX)/bin", "\tmkdir -p $(DESTDIR)$(PREFIX)/bin"
    system "make"
    mkdir [bin, include]
    system "make", "install", "PREFIX=#{prefix}"
    include.install "src/tinyFA/tinyfa.hpp", "src/tinyFA/pliib.hpp"
  end

  test do
    (testpath/"test.gfa").write <<~EOS
      H\tVN:Z:1.0
      S\t1\tACGTACGT\tLN:i:8
      L\t1\t+\t1\t+\t4M
    EOS
    assert_equal "Number of nodes: 1\nNumber of edges: 1\nNumber of links: 1\nNumber of containments: 0\n",
                  shell_output("#{bin}/gfak stats -n -e test.gfa")
  end
end
