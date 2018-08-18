class Shovill < Formula
  desc "De novo assembly pipeline for Illumina paired-end reads"
  homepage "https://github.com/tseemann/shovill"
  url "https://github.com/tseemann/shovill/archive/v1.0.1.tar.gz"
  sha256 "3985a1381a009d2335645627c14301395ab82f0ad6a7f48f7e1abab3303cfec9"
  head "https://github.com/tseemann/shovill.git"

  bottle :unneeded

  depends_on "bwa"
  depends_on "flash"
  depends_on "lighter"
  depends_on "mash"
  depends_on "megahit"
  depends_on "pigz"
  depends_on "pilon"
  depends_on "samclip"
  depends_on "samtools"
  depends_on "seqtk"
  depends_on "skesa"
  depends_on "spades"
  depends_on "trimmomatic"
  depends_on "velvet"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shovill --version 2>&1")
    assert_match "Illumina", shell_output("#{bin}/shovill --help 2>&1")
    system "#{bin}/shovill", "--check"
  end
end
