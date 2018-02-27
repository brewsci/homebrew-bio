class Gfakluge < Formula
  desc "C++ library and utilities for Graphical Fragment Assembly (GFA)"
  homepage "https://github.com/edawson/gfakluge"
  url "https://github.com/edawson/gfakluge/archive/0.1.0.tar.gz"
  sha256 "a5cc74a5733b2e17cc5819749c1a6a696620e5bc247663231112199bc891bc1e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "213958aa6c3d4059a23ff1a24ebd10ee5a3e2f8b9f44ef1befe7544f046eecf8" => :sierra_or_later
    sha256 "71cc2877ce102e0ad35532458aaaaf34ffb93857999e7d0802681bfaaa04e3a1" => :x86_64_linux
  end

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
