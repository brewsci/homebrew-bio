class Bfc < Formula
  # Li_2015: "https://doi.org/10.1093/bioinformatics/btv290"
  desc "High-performance error correction for Illumina resequencing data"
  homepage "https://github.com/lh3/bfc"
  url "https://github.com/lh3/bfc/archive/submitted-v1.tar.gz"
  version "r175"
  sha256 "0fad5807a417f8cc033b5deea04c0fa763947e55415372f89bd2914df48154b7"

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
