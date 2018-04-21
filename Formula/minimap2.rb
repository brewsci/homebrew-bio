class Minimap2 < Formula
  # cite Li_2018: "https://arxiv.org/abs/1708.01492"
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.10/minimap2-2.10.tar.bz2"
  sha256 "52b36f726ec00bfca4a2ffc23036d1a2b5f96f0aae5a92fd826be6680c481c20"
  revision 1
  head "https://github.com/lh3/minimap2.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "37b3ef49a46ede559bfa41a61e31bfab9321e202e0929d0fc3bf6564b597b393" => :sierra_or_later
    sha256 "03412ea8d74d5962bb9ed97b6a7454f967f5441067dcde591a670513ac24eecb" => :x86_64_linux
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
