class Minimap2 < Formula
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.7/minimap2-2.7.tar.bz2"
  sha256 "19d6dbeaa19440e0199ae9bebaf34349ef2e2696a127206ccf80498ade55d408"
  head "https://github.com/lh3/minimap2.git"
  # cite "https://arxiv.org/abs/1708.01492"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "a53d9a577ed3592cd45cb1d3456b27e990c3c64faa163dfc25b1afa99086d346" => :sierra_or_later
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
