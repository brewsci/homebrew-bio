class Bowtie < Formula
  # cite Langmead_2009: "https://doi.org/10.1186/gb-2009-10-3-r25"
  desc "Ultrafast memory-efficient short read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  url "https://github.com/BenLangmead/bowtie/archive/v1.2.3.tar.gz"
  sha256 "86402114caeacbb3a3030509cb59f0b7e96361c7b3ee2dd50e2cd68200898823"
  head "https://github.com/BenLangmead/bowtie.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "68c4f8f9e4437c7831fb0f3e09fa32acef47a763db231c700ee2f60fa93c52ff" => :sierra
    sha256 "f517d5d13bdb58b788e621a2771702acfb81387eaafabe194b4622c294af9e76" => :x86_64_linux
  end

  depends_on "tbb"
  depends_on "python@2" => :test unless OS.mac? || which("python")

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
