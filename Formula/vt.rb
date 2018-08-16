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
    sha256 "23e7584355ed608910355ec07ac6c368f98fa06bfec3fef933d15a7532f19970" => :sierra_or_later
    sha256 "66c9fb58c11513fff8b4724525787704aeb7f058eb3039cb007daa514cb07e09" => :x86_64_linux
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
