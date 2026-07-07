class Legsta < Formula
  desc "In silico Legionella pneumophila Sequence Based Typing"
  homepage "https://github.com/tseemann/legsta"
  url "https://github.com/tseemann/legsta/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "73db39cdc695e6a889b0b0092c2eda4119e9fa463e5992e9b5de91186cc97101"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "f911328d0fc033f93d5c8c60be93fd13498ec6ae91e8e27ce0ee54ec57d3953d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "42753e6bd8bb2cd596026027ee92644d43c2c60b3e3b6896b0790218d9fd05aa"
  end

  depends_on "any2fasta"
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
