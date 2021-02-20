class Vt < Formula
  # Tan_2015: "https://doi.org/10.1093/bioinformatics/btv112"
  desc "Toolset for short variant discovery from NGS data"
  homepage "https://genome.sph.umich.edu/wiki/Vt"
  url "https://github.com/atks/vt/archive/0.5772.tar.gz"
  sha256 "b147520478a2f7c536524511e48133d0360e88282c7159821813738ccbda97e7"
  license "MIT"
  revision 2
  head "https://github.com/atks/vt.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any, sierra:       "43c34b6bf2d3209088a1e6ce61e37844ef3bbf08b871861214714ce10b18f707"
    sha256 cellar: :any, x86_64_linux: "a2f0c3b7e3078719d39b7d257d964f19d327e3a3638c9e1397d804588da811f6"
  end

  depends_on "gcc" if OS.mac? # Fix error: static_assert failed

  uses_from_macos "zlib"

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
