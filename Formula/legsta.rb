class Legsta < Formula
  desc "In silico Legionella pneumophila Sequence Based Typing"
  homepage "https://github.com/tseemann/legsta"
  url "https://github.com/tseemann/legsta/archive/v0.5.1.tar.gz"
  sha256 "a094d0e82af988d5fc2ab0ad9c55c23f7f20d0dd424470a28daf00a59a0190b5"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3e0dd6f166f5ec9784ee0a5ed0a8e4ae2e3a578b2662731a4271092d7dcf3661" => :sierra
    sha256 "10d8a249d6e1a22bc4d8cc06e8dd6cf3f941d6bc1f07905fbb5a29821a98b889" => :x86_64_linux
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
