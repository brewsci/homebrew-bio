class Quicktree < Formula
  desc "Phylogenetic neighbor-joining tree builder"
  homepage "https://www.sanger.ac.uk/science/tools/quicktree"
  url "https://github.com/khowe/quicktree/archive/v2.4.tar.gz"
  sha256 "9d9743d2cfe93659fd4ec3c098f0fcfa38f4bfe61d6596e2568221101b90b812"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "532ff0ba43db37406937641d3d8b24aead47201e09f04cabc075352b787f5d7d" => :sierra
    sha256 "9d79252329c90936a71615f4b06ca1d74e1c18f461c8bbd091fdb5c9fc752dac" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "quicktree"
  end

  test do
    assert_match "UPGMA", shell_output("#{bin}/quicktree -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/quicktree -v 2>&1")
  end
end
