class Quicktree < Formula
  desc "Phylogenetic neighbor-joining tree builder"
  homepage "https://www.sanger.ac.uk/science/tools/quicktree"
  url "https://github.com/khowe/quicktree/archive/v2.3.tar.gz"
  sha256 "3739f7962ce72c1d3c86ba0a3faa82cc60749f6d9f627c1aba3729b6c881dee4"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0cd00f5aa355ac460ba8ce19dead91352e15ac756d605851cd89a19a6193f57a" => :sierra_or_later
    sha256 "28b56fac02e1cbd8757c83df127e4c3fe147e60b755bf642bce8ca969a096df8" => :x86_64_linux
  end

  def install
    # https://github.com/khowe/quicktree/issues/8
    inreplace "src/distancemat.c", "strlen(identifier)", "(strlen(identifier)+1)"
    system "make"
    bin.install "quicktree"
  end

  test do
    assert_match "UPGMA", shell_output("#{bin}/quicktree -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/quicktree -v 2>&1")
  end
end
