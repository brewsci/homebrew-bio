class Snippy < Formula
  desc "Rapid bacterial SNP calling and core genome alignments"
  homepage "https://github.com/tseemann/snippy"
  url "https://github.com/tseemann/snippy/archive/4.0-dev.tar.gz"
  version "4.0"
  sha256 "e0400bfa95343cad52fdb54ad9ec0c8befbe68cbc44a4f27a0b8f88a331dc4f7"
  head "https://github.com/tseemann/snippy.git"

  depends_on "bcftools"
  depends_on "bioperl"
  depends_on "bwa"
  depends_on "freebayes"
  depends_on "parallel"
  depends_on "samtools"
  depends_on "snpeff"
  depends_on "vcflib"

  def install
    prefix.install Dir["*"]
    bioperl = Formula["bioperl"].libexec/"lib/perl5"
    Dir[bin/"*"].each do |script|
      inreplace script, "use strict;\n", "use strict;\nuse lib '#{bioperl}';\n"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snippy --version")
    system "#{bin}/snippy", "--check"
  end
end
