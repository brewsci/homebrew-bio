class Minimap2 < Formula
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.3/minimap2-2.3.tar.bz2"
  sha256 "a7bad55254bc4011d4501c2a5a21fd30443ffd04cbcbe28ba190ae160f7955e6"
  head "https://github.com/lh3/minimap2.git"
  # doi "https://arxiv.org/abs/1708.01492"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "a53d9a577ed3592cd45cb1d3456b27e990c3c64faa163dfc25b1afa99086d346" => :sierra
    sha256 "ee7edc40aa7ea0f8f5c88b2176bcdfe56dca6cb71581b7c94592d2f19605b90d" => :x86_64_linux
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
