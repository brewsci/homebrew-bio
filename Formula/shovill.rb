class Shovill < Formula
  desc "De novo assembly pipeline for Illumina paired-end reads"
  homepage "https://github.com/tseemann/shovill"
  url "https://github.com/tseemann/shovill/archive/v1.1.0.tar.gz"
  sha256 "b7323e6586238821202cf9644963e584e7397a5cee23e564d00b07fcb344ecd2"
  license "GPL-3.0"
  head "https://github.com/tseemann/shovill.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "7348bc9750cc3ed0ec6cec4c1aa55c2e36475e2d791d6edc383429d0677f4ee6" => :catalina
    sha256 "4c8964af516ab407aa754466600409e9e0dd262ed1804211729f34b20cfdc1ea" => :x86_64_linux
  end

  depends_on "brewsci/bio/flash"
  depends_on "brewsci/bio/kmc"
  depends_on "brewsci/bio/lighter"
  depends_on "brewsci/bio/megahit"
  depends_on "brewsci/bio/pilon"
  depends_on "brewsci/bio/samclip"
  depends_on "brewsci/bio/skesa"
  depends_on "brewsci/bio/trimmomatic"
  depends_on "brewsci/bio/velvet"
  depends_on "bwa"
  depends_on "pigz"
  depends_on "samtools"
  depends_on "seqtk"
  depends_on "spades"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shovill --version 2>&1")
    assert_match "Illumina", shell_output("#{bin}/shovill --help 2>&1")
    system "#{bin}/shovill", "--check"
  end
end
