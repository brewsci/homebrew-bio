class Legsta < Formula
  desc "In silico Legionella pneumophila Sequence Based Typing"
  homepage "https://github.com/tseemann/legsta"
  url "https://github.com/tseemann/legsta/archive/v0.3.7.tar.gz"
  sha256 "4d721a1dcd64b44311992610484e699fb05affb4a32b75aa62225b317cb81163"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e0dd6f166f5ec9784ee0a5ed0a8e4ae2e3a578b2662731a4271092d7dcf3661" => :sierra
    sha256 "10d8a249d6e1a22bc4d8cc06e8dd6cf3f941d6bc1f07905fbb5a29821a98b889" => :x86_64_linux
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
