class Minimap2 < Formula
  # cite Li_2018: "https://doi.org/10.1093/bioinformatics/bty191"
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.19/minimap2-2.19.tar.bz2"
  sha256 "47f3ee7960c3ea5aa174e454fc5c2d47e1687ad3dade131082e3b6a04e7eca52"
  head "https://github.com/lh3/minimap2.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "b17901e13808c8b43d2052dae46eb4061db8e917d922c2a6020c25a334e613c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4b6b8c1f4bd2c9c6d470ada3b2a5f0a34701ba40fd238b7190a41f56c5c6f87f"
  end

  depends_on "brewsci/bio/k8" # for paftools.js

  uses_from_macos "zlib"

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
    assert_match(/\d/, shell_output("#{bin}/paftools version 2>&1"))
  end
end
