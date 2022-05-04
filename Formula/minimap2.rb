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
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "7be2334fd489cc7e33085f04e3ef2b587e5de5db77bb4a771d5ac1a7d41e09f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9529104f9b6dd5e871ee3d1ca8d90bb0b7d4ec916a5fc89edc5ad5987c5ad780"
  end

  depends_on "brewsci/bio/k8" # for paftools.js

  uses_from_macos "zlib"

  def install
    if Hardware::CPU.arm? && OS.mac?
      system "make", "arm_neon=1", "aarch64=1"
    else
      system "make"
    end
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
