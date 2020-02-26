class Legsta < Formula
  desc "In silico Legionella pneumophila Sequence Based Typing"
  homepage "https://github.com/tseemann/legsta"
  url "https://github.com/tseemann/legsta/archive/v0.5.1.tar.gz"
  sha256 "a094d0e82af988d5fc2ab0ad9c55c23f7f20d0dd424470a28daf00a59a0190b5"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f911328d0fc033f93d5c8c60be93fd13498ec6ae91e8e27ce0ee54ec57d3953d" => :catalina
    sha256 "42753e6bd8bb2cd596026027ee92644d43c2c60b3e3b6896b0790218d9fd05aa" => :x86_64_linux
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
