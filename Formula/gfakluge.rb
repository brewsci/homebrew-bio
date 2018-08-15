class Gfakluge < Formula
  desc "C++ library and utilities for Graphical Fragment Assembly (GFA)"
  homepage "https://github.com/edawson/gfakluge"
  url "https://github.com/edawson/gfakluge/archive/0.3.0.tar.gz"
  sha256 "840a5849ec6a9cce9390cc9526f2935483e65bfe8715b5dab2c9833ae30a40b4"
  head "https://github.com/edawson/gfakluge.git"

  fails_with :clang # needs openmp

  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "532ead613d78cb589ab2ddbe088edc684756b66f637f31b199bd155f40547f87" => :sierra_or_later
    sha256 "d68b72627b3deb02ee8028719ea1dd1d290b10632384093c6099d27196cd51e2" => :x86_64_linux
  end

  def install
    system "make"
    include.install "src/gfakluge.hpp", "src/tinyFA/tinyfa.hpp", "src/tinyFA/pliib.hpp"
    lib.install "libgfakluge.a"
    bin.install %w[gfak]
  end

  test do
    (testpath/"test.gfa").write <<~EOS
      H\tVN:Z:1.0
      S\t1\tACGTACGT\tLN:i:8
      L\t1\t+\t1\t+\t4M
    EOS
    assert_equal "Number of nodes: 1\nNumber of edges: 1\nNumber of links: 1\nNumber of containments: 0\n", shell_output("#{bin}/gfak stats -n -e test.gfa")
  end
end
