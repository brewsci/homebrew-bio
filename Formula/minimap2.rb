class Minimap2 < Formula
  # cite Li_2018: "https://doi.org/10.1093/bioinformatics/bty191"
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.24/minimap2-2.24.tar.bz2"
  sha256 "9dd4c31ff082182948944bcdad6d328f64f09295d10547d72eba24189880a615"
  head "https://github.com/lh3/minimap2.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "971cc33d2cafd5d2a99273aa5931986a4422f3590f235c36b514126023cb6744"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3448c9801e3e5a55c251b196141e1d71160069db7702ac11e764934c151aee8a"
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
