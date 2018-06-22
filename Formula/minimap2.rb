class Minimap2 < Formula
  # cite Li_2018: "https://arxiv.org/abs/1708.01492"
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.11/minimap2-2.11.tar.bz2"
  sha256 "c22607eef1c819c2daba4b09aaea04d4d34a7587d14379704d7e15e39f01fecc"
  head "https://github.com/lh3/minimap2.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "934e3c21cc5e36f6bdb6c61f204b76773b9c54d51338bdb3c584d9dc4307603d" => :sierra_or_later
    sha256 "36489f784fcc18961dd6255ab64b05bf1d23fcfd42c7a51dce5582061552bb65" => :x86_64_linux
  end

  depends_on "k8" # for paftools.js
  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "minimap2"
    bin.install "misc/paftools.js"
    man1.install "minimap2.1"
    pkgshare.install "python", "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minimap2 --version 2>&1")
    assert_match /\d/, shell_output("#{bin}/paftools.js version 2>&1")
  end
end
