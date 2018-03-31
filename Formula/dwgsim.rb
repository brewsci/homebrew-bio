class Dwgsim < Formula
  desc "Whole Genome Simulator for Next-Generation Sequencing"
  homepage "https://github.com/nh13/DWGSIM"
  url "https://github.com/nh13/DWGSIM.git",
    :tag => "dwgsim.0.1.12",
    :revision => "4fd56bf39dbba3801856fa0512aed68726e3ca6e"
  head "https://github.com/nh13/DWGSIM.git"

  unless OS.mac?
    # dwgsim builds a vendored copy of samtools, which requires (static) ncurses.
    depends_on "ncurses" => :build
    depends_on "zlib"
  end

  def install
    system "make"
    bin.install "dwgsim", "dwgsim_eval", Dir["scripts/*.p?"]
    pkgshare.install "testdata"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dwgsim -h 2>&1", 1)
  end
end
