class Gfakluge < Formula
  desc "C++ library and utilities for Graphical Fragment Assembly (GFA)"
  homepage "https://github.com/edawson/gfakluge"
  url "https://github.com/edawson/gfakluge/archive/0.3.1.tar.gz"
  sha256 "30b2f177906fa24adb78e6ecb3edc23f2f6f9a097b870fa16a9e8d54e4d5ea58"
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
    sha256 "115c14604c83be964cb54a476a76680475ccff173f61d0de572fcb3088c68c25" => :sierra
    sha256 "1a092a48de508127d6216f1929f8daf24b2dcaf431159269cb053daaf740677f" => :x86_64_linux
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
