class Vt < Formula
  # Tan_2015: "https://doi.org/10.1093/bioinformatics/btv112"
  desc "Toolset for short variant discovery from NGS data"
  homepage "https://genome.sph.umich.edu/wiki/Vt"
  url "https://github.com/atks/vt/archive/0.5772.tar.gz"
  sha256 "b147520478a2f7c536524511e48133d0360e88282c7159821813738ccbda97e7"
  revision 1
  head "https://github.com/atks/vt.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "1b599e67c480a2650694804e14e8df4d126a3094092f44f4f1bf814d22fe1061" => :sierra
    sha256 "fa81d9983854db901ee2d868e3a4ffc3195f042e01f9cfa54d78ea020726b59c" => :x86_64_linux
  end

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
