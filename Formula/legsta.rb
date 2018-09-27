class Legsta < Formula
  desc "In silico Legionella pneumophila Sequence Based Typing"
  homepage "https://github.com/tseemann/legsta"
  url "https://github.com/tseemann/legsta/archive/v0.3.2.tar.gz"
  sha256 "e734a419275cf85898b99ef03f79b98111a5fd443352b1d867396880b0902e04"

  depends_on "ispcr"

  def install
    rm "bin/isPcr" # remove bundled binary
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/legsta --version")
    assert_match "734", shell_output("#{bin}/legsta #{prefix}/test/NC_018140.fna 2>&1")
  end
end
