class Gfakluge < Formula
  desc "C++ library and utilities for Graphical Fragment Assembly (GFA)"
  homepage "https://github.com/edawson/gfakluge"
  url "https://github.com/edawson/gfakluge/archive/0.1.0.tar.gz"
  sha256 "a5cc74a5733b2e17cc5819749c1a6a696620e5bc247663231112199bc891bc1e"

  def install
    system "make"
    include.install "src/gfakluge.hpp"
    lib.install "libgfakluge.a"
    bin.install %w[gfa_diff gfa_ids gfa_merge gfa_sort gfa_spec_convert gfa_stats]
  end

  test do
    (testpath/"test.gfa").write <<~EOS
      H\tVN:Z:1.0
      S\t1\tACGTACGT\tLN:i:8
      L\t1\t+\t1\t+\t4M
    EOS
    assert_equal "Number of nodes: 1\nNumber of edges: 1\nTotal graph length in basepairs: 8\n", shell_output("#{bin}/gfa_stats -s -i test.gfa")
  end
end
