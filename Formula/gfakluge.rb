class Gfakluge < Formula
  desc "C++ library and utilities for Graphical Fragment Assembly (GFA)"
  homepage "https://github.com/edawson/gfakluge"
  url "https://github.com/edawson/gfakluge/archive/1.0.0.tar.gz"
  sha256 "258e0048fa02ab680f4a8b8d9237aa1b56983804d30c1dbae56e4984fd6791d0"
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
