class Bowtie < Formula
  # cite Langmead_2009: "https://doi.org/10.1186/gb-2009-10-3-r25"
  desc "Ultrafast memory-efficient short read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  url "https://github.com/BenLangmead/bowtie/archive/v1.2.2_p1.tar.gz"
  version "1.2.2_p1"
  sha256 "e1b02b2e77a0d44a3dd411209fa1f44f0c4ee304ef5cc83f098275085740d5a1"
  head "https://github.com/BenLangmead/bowtie.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "d6d3a56db17786537453e3c841b4938fd190970e7534eaee5446bbae55254fda" => :sierra
    sha256 "f5d9b8994e1fcb589b3eb9290cffa78243463dc4ec0c8f2a21cb9831defcc630" => :x86_64_linux
  end

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
