class Legsta < Formula
  desc "In silico Legionella pneumophila Sequence Based Typing"
  homepage "https://github.com/tseemann/legsta"
  url "https://github.com/tseemann/legsta/archive/v0.3.3.tar.gz"
  sha256 "a64ad90721db4e130dc66122662aaac6ad98c6247f00573486dfa56d72ef8008"

  bottle do
    cellar :any_skip_relocation
    sha256 "562932340889a5ffbc9c88bcf543655ed55858dd794d87e2cb00979d1994184a" => :sierra
    sha256 "a46963b1877423873b6175dcb0ac58f39d3d62ec7834e5ef48aa4424a027e0f9" => :x86_64_linux
  end

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
