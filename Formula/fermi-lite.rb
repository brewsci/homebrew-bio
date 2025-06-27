class FermiLite < Formula
  # cite Li_2012: "https://doi.org/10.1093/bioinformatics/bts280"
  desc "Assembling Illumina short reads in small regions"
  homepage "https://github.com/lh3/fermi-lite"
  url "https://github.com/lh3/fermi-lite/archive/v0.1.tar.gz"
  sha256 "661053bc7213b575912fc7be9cdfebc1c92a10319594a8e8f18542c9e2adda6e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 sierra:       "7f5893730da8f22a792c26c7c4885a1a97d7f3074a4aba97ffc26c08cd869793"
    sha256 x86_64_linux: "0bdc4c570af402f510dee46e368b538dacb43d36ebfe479d5e4a5ca6321a62be"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "fml-asm"
    lib.install "libfml.a"
    include.install "fml.h"
  end

  test do
    assert_match "heterozygotes", shell_output("#{bin}/fml-asm 2>&1", 1)
  end
end
