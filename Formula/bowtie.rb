class Bowtie < Formula
  include Language::Python::Shebang

  # cite Langmead_2009: "https://doi.org/10.1186/gb-2009-10-3-r25"
  desc "Ultrafast memory-efficient short read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  url "https://github.com/BenLangmead/bowtie/archive/v1.3.0.tar.gz"
  sha256 "d7c2d982a67884909f284a0ff150b56b20127cd7a1ced461c3c4c03e6a6374c5"
  license "Artistic-2.0"
  head "https://github.com/BenLangmead/bowtie.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "7fa2de70af58f8e5da3a0eb5e2027c21f71d9771ce434d3c5e76095587540300" => :catalina
    sha256 "da870f5995114f425d58663e971f01ea8aa88d41224b6eafdca348362614836b" => :x86_64_linux
  end

  depends_on "python"
  depends_on "tbb"

  def install
    system "make", "install", "prefix=#{prefix}"
    bin.find { |f| rewrite_shebang detected_python_shebang, f }

    doc.install "MANUAL", "NEWS", "TUTORIAL"
    pkgshare.install "scripts", "genomes", "indexes", "reads"
  end

  test do
    Dir[bin/"*"].each do |exe|
      assert_match "usage", shell_output("#{exe} --help 2>&1")
    end
  end
end
