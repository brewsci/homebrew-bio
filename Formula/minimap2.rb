class Minimap2 < Formula
  # cite Li_2018: "https://arxiv.org/abs/1708.01492"
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.13/minimap2-2.13.tar.bz2"
  sha256 "ac1ce248f4a9c8d47397204ada38bb4739fc2c9b81e6c0894e074b5e89deb76c"
  head "https://github.com/lh3/minimap2.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "5a4d1c9e49a1bcc135772c22c0d9b90e24a77a43bc50d35a803cf4f43db6a467" => :sierra
    sha256 "58aa3b4418fd21d82302c5572918c9005d497101bd1997b40b4a0d9b9a887914" => :x86_64_linux
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
