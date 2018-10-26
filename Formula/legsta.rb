class Legsta < Formula
  desc "In silico Legionella pneumophila Sequence Based Typing"
  homepage "https://github.com/tseemann/legsta"
  url "https://github.com/tseemann/legsta/archive/v0.3.2.tar.gz"
  sha256 "e734a419275cf85898b99ef03f79b98111a5fd443352b1d867396880b0902e04"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f1c3d9ca09f4b1285b03bdd0c341aaf950d432f3fdd1eec9c9d149c732240b77" => :sierra
    sha256 "7c3d1a4dc8041079d56d4f5456e9f2c87e224db1b4659b498bbcd9fd71301626" => :x86_64_linux
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
