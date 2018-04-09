class Quicktree < Formula
  desc "Phylogenetic neighbor-joining tree builder"
  homepage "https://www.sanger.ac.uk/science/tools/quicktree"
  url "https://github.com/khowe/quicktree/archive/v2.3.tar.gz"
  sha256 "3739f7962ce72c1d3c86ba0a3faa82cc60749f6d9f627c1aba3729b6c881dee4"
  head "https://github.com/khowe/quicktree.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "536ff4f63edd1ce2bf6e8890894ded4a6f9016ff736110f24d848c59bfd014e2" => :sierra_or_later
    sha256 "6816df014b3490de99c0404cafcf053d5297c90e366edb924205cff1ecba1f1a" => :x86_64_linux
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
