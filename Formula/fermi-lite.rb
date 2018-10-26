class FermiLite < Formula
  # cite Li_2012: "https://doi.org/10.1093/bioinformatics/bts280"
  desc "Assembling Illumina short reads in small regions"
  homepage "https://github.com/lh3/fermi-lite"
  url "https://github.com/lh3/fermi-lite/archive/v0.1.tar.gz"
  sha256 "661053bc7213b575912fc7be9cdfebc1c92a10319594a8e8f18542c9e2adda6e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "7f5893730da8f22a792c26c7c4885a1a97d7f3074a4aba97ffc26c08cd869793" => :sierra
    sha256 "0bdc4c570af402f510dee46e368b538dacb43d36ebfe479d5e4a5ca6321a62be" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

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
