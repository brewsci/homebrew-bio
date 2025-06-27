class Minimap2 < Formula
  # cite Li_2018: "https://doi.org/10.1093/bioinformatics/bty191"
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.18/minimap2-2.18.tar.bz2"
  sha256 "7a55101d58ecaec545db51079ad82b214632dc697ee67290b6dc34cc70dbeeb4"
  head "https://github.com/lh3/minimap2.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "c163b74d4fcf47047f800359feadb480e4f4f67e0a71a074d1d2109bc3d64c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "77ca218d3ff513c8d7005a2f09dd651eaaabb7994e00d5c7f64a7ddc440fe56d"
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
