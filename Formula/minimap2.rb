class Minimap2 < Formula
  # cite Li_2018: "https://arxiv.org/abs/1708.01492"
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.8/minimap2-2.8.tar.bz2"
  sha256 "9899e548f4f4cbf2b9a5c3b20facb8dd583ee9f39be7ac0c3b0bdeb5ca3b0cc2"
  head "https://github.com/lh3/minimap2.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "5681b02a8f9dd85b3243f1ddc6cd518d5ce7eb4716e32de35021b067b2b487c0" => :sierra_or_later
    sha256 "ade0e4c0343a5ac92af3c7ac411192b655453dffbc2292e482360cd6ea44c555" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "minimap2"
    man1.install "minimap2.1"
    pkgshare.install "python", "test"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/minimap2 --help 2>&1")
  end
end
