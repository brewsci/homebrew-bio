class Vt < Formula
  # Tan_2015: "https://doi.org/10.1093/bioinformatics/btv112"
  desc "Toolset for short variant discovery from NGS data"
  homepage "https://genome.sph.umich.edu/wiki/Vt"
  url "https://github.com/atks/vt/archive/0.5772.tar.gz"
  sha256 "b147520478a2f7c536524511e48133d0360e88282c7159821813738ccbda97e7"
  head "https://github.com/atks/vt.git"

  depends_on "gcc" if OS.mac? # Fix error: static_assert failed
  depends_on "zlib" unless OS.mac?

  fails_with :clang # Fix error: static_assert failed

  def install
    system "make"
    system "test/test.sh"
    bin.install "vt"
    pkgshare.install "test"
  end

  test do
    assert_match "multi_partition", shell_output("#{bin}/vt 2>&1")
  end
end
