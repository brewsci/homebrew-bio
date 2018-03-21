class Bowtie < Formula
  # cite Langmead_2009: "https://doi.org/10.1186/gb-2009-10-3-r25"
  desc "Ultrafast memory-efficient short read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  url "https://github.com/BenLangmead/bowtie/archive/v1.2.2_p1.tar.gz"
  version "1.2.2_p1"
  sha256 "e1b02b2e77a0d44a3dd411209fa1f44f0c4ee304ef5cc83f098275085740d5a1"
  head "https://github.com/BenLangmead/bowtie.git"

  depends_on "tbb"

  def install
    system "make", "install", "prefix=#{prefix}"

    doc.install "MANUAL", "NEWS", "TUTORIAL"
    pkgshare.install "scripts", "genomes", "indexes", "reads"
  end

  test do
    Dir[bin/"*"].each do |exe|
      assert_match "usage", shell_output("#{exe} --help 2>&1")
    end
  end
end
