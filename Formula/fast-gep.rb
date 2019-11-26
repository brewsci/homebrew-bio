class FastGep < Formula
  #  cite Zhang_2018: "https://doi.org/10.1093/bioinformatics/bty195"
  desc "Fast genealogical relationship evaluation of bacterial genomes"
  homepage "https://github.com/jizhang-nz/fast-GeP"
  url "https://github.com/jizhang-nz/fast-GeP/archive/1.0.tar.gz"
  sha256 "017ac4b34aa026b5a97460a9846c01d53eaed2b5ce4da792df8535a6e58ab7d8"

  depends_on "blast"
  depends_on "diamond"
  depends_on "mafft"

  uses_from_macos "gzip"
  uses_from_macos "perl"
  uses_from_macos "zip"

  def install
    bin.install "fast-GeP.pl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fast-GeP.pl -h 2>&1")
  end
end
