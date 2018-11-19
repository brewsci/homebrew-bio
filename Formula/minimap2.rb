class Minimap2 < Formula
  # cite Li_2018: "https://arxiv.org/abs/1708.01492"
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.14/minimap2-2.14.tar.bz2"
  sha256 "9088b785bb0c33488ca3a27c8994648ce21a8be54cb117f5ecee26343facd03b"
  head "https://github.com/lh3/minimap2.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0b1f28add0d512504654e6b7f7bc9efe1f9ea1ce14b3496e9d5507a22f0c1ddc" => :sierra
    sha256 "69f9073fc28f997e984be84cc682ad5be5c946f567bac6f8017b192a7b4677b0" => :x86_64_linux
  end

  depends_on "k8" # for paftools.js
  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "minimap2"
    bin.install "misc/paftools.js"
    bin.install_symlink "paftools.js" => "paftools"
    man1.install "minimap2.1"
    pkgshare.install "python", "test", "misc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minimap2 --version 2>&1")
    assert_match /\d/, shell_output("#{bin}/paftools version 2>&1")
  end
end
