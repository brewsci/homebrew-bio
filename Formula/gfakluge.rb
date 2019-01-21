class Gfakluge < Formula
  desc "C++ library and utilities for Graphical Fragment Assembly (GFA)"
  homepage "https://github.com/edawson/gfakluge"
  url "https://github.com/edawson/gfakluge/archive/1.1.0.tar.gz"
  sha256 "1b3114fc3004b2ce2210c469a1894a81cba252e5b35c770ba7be63452e5e448a"
  head "https://github.com/edawson/gfakluge.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "81a6144046840e79918e5b9313726ad6aab5eb5b044bee2932e022da0c05e3f1" => :sierra
    sha256 "53ca94220975cdc85360476be91613030c7fd15ecd20f1524ba90c7798a05696" => :x86_64_linux
  end

  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  fails_with :clang # needs openmp

  def install
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
    assert_equal "Number of nodes: 1\nNumber of edges: 1\nNumber of links: 1\nNumber of containments: 0\n", shell_output("#{bin}/gfak stats -n -e test.gfa")
  end
end
