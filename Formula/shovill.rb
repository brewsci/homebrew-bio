class Shovill < Formula
  desc "Faster Spades-based de novo genome assembly"
  homepage "https://github.com/tseemann/shovill"
  url "https://github.com/tseemann/shovill/archive/v0.9.0.tar.gz"
  sha256 "0a428609ec39661eb4af417d24e1a5d4cfe5cbc120f7999914c19406fddd41cd"
  head "https://github.com/tseemann/shovill.git"

  bottle :unneeded

  depends_on "bwa"
  depends_on "flash"
  depends_on "kmc"
  depends_on "lighter"
  depends_on "pigz"
  depends_on "pilon"
  depends_on "samtools"
  depends_on "seqtk"
  depends_on "spades"
  depends_on "trimmomatic"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shovill --version 2>&1")
    assert_match "Faster", shell_output("#{bin}/shovill --help 2>&1")
    assert_match "Using", shell_output("#{bin}/shovill --check 2>&1")
  end
end
