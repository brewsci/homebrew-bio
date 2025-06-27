class Dwgsim < Formula
  desc "Whole Genome Simulator for Next-Generation Sequencing"
  homepage "https://github.com/nh13/DWGSIM"
  url "https://github.com/nh13/DWGSIM.git",
    tag:      "dwgsim.0.1.12",
    revision: "4fd56bf39dbba3801856fa0512aed68726e3ca6e"
  license "GPL-2.0"
  head "https://github.com/nh13/DWGSIM.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "f6794802ed9615c73fe240a0e322c6ab9e773b2e22c05482908f38f85c15c653"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dd36a513fa17141d0a98a59b985f7965c80498b30c1fa2d8dabba3cc1d42929a"
  end

  uses_from_macos "ncurses" => :build
  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "dwgsim", "dwgsim_eval", Dir["scripts/*.p?"]
    pkgshare.install "testdata"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dwgsim -h 2>&1", 1)
  end
end
