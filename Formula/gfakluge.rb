class Gfakluge < Formula
  desc "C++ library and utilities for Graphical Fragment Assembly (GFA)"
  homepage "https://github.com/edawson/gfakluge"
  url "https://github.com/edawson/gfakluge/archive/0.2.2.tar.gz"
  sha256 "cad8293786d1567f3eb74b4bc9f79c2871715a7ae7f7f6e51ad7528bcf873d5c"

  fails_with :clang # needs openmp
  depends_on "gcc" if OS.mac? # for openmp

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "532ead613d78cb589ab2ddbe088edc684756b66f637f31b199bd155f40547f87" => :sierra_or_later
    sha256 "d68b72627b3deb02ee8028719ea1dd1d290b10632384093c6099d27196cd51e2" => :x86_64_linux
  end

  def install
    system "make"
    include.install "src/gfakluge.hpp", "src/pliib.hpp"
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
