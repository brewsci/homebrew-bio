class Bfc < Formula
  # Li_2015: "https://doi.org/10.1093/bioinformatics/btv290"
  desc "High-performance error correction for Illumina resequencing data"
  homepage "https://github.com/lh3/bfc"
  url "https://github.com/lh3/bfc/archive/69ab176e7aac4af482d7d8587e45bfe239d02c96.tar.gz"
  version "r181"
  sha256 "4f510557ea5fb9ed179bc21d9ffc85c0ae346525b56e3b72bf6204d64f6bfb8b"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "96f0c5343aba43216d0f25c7ee8060eb68645a70904d81689b5da2333cfe8e2e" => :sierra_or_later
    sha256 "85ad1e0d8290a563e4afeac4b9691330ba226c2b3142b214b169ad77d67abde8" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "bfc", "hash2cnt"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bfc -v 2>&1")
  end
end
