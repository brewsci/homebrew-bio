class Bfc < Formula
  # Li_2015: "https://doi.org/10.1093/bioinformatics/btv290"
  desc "High-performance error correction for Illumina resequencing data"
  homepage "https://github.com/lh3/bfc"
  url "https://github.com/lh3/bfc/archive/69ab176e7aac4af482d7d8587e45bfe239d02c96.tar.gz"
  version "r181"
  sha256 "4f510557ea5fb9ed179bc21d9ffc85c0ae346525b56e3b72bf6204d64f6bfb8b"
  license "MIT"

  livecheck do
    url "https://raw.githubusercontent.com/lh3/bfc/master/bfc.c"
    regex(/^#define BFC_VERSION "(r\d+)"$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "ae209def35d23b0885832d1e14c4ac37e05daae151c7196bca597d38a5274f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3a8a77f320e0d5ab85b1a05c979f9e94e2b1ddf9465c71b95d1559a0c52287ba"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "bfc", "hash2cnt"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bfc -v 2>&1")
  end
end
