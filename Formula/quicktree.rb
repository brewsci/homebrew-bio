class Quicktree < Formula
  desc "Phylogenetic neighbor-joining tree builder"
  homepage "https://github.com/khowe/quicktree"
  url "https://github.com/khowe/quicktree/archive/v2.5.tar.gz"
  sha256 "731aa845ce3f1f0645bd0df2b54df75f78fce065d6a3ddc47fedf4bdcb11c248"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "0f0d3d53c06ddbb56ad38f6263a49d0fd52b3aed7e99225a8dc286ce2857f157"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3f79f6279f053a919147c2c6625a3ecbaafaf0e5e14afd0aa881bf3b80bb934e"
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
