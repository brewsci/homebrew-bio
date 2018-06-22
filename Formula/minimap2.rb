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
    sha256 "702ddfa3eb6a89bdc157999e520d01cc6a86ee39411d7c0c1e913636869f0399" => :sierra_or_later
    sha256 "307aa6643b930da5db864d5be29fef3730fa7e9b0089150da30d39a7e55b7156" => :x86_64_linux
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
