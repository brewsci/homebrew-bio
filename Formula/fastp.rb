class Fastp < Formula
  # cite Chen_2018: "https://doi.org/10.1101/274100"
  desc "Ultrafast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/v0.19.4.tar.gz"
  sha256 "f20f1f3b1d1afa9ac347c9aaacc41782cac1665eda730e84523db6a1f0227c5f"
  head "https://github.com/OpenGene/fastp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "dc4ef5eb181cb1675670dbaddd45ac811e59a9d948f2a57cc7c8730f1fe2f187" => :sierra
    sha256 "63cc989f0792f129bdc32ec6f81813562178e34ec4bd91c90839864e8fae9c2b" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    system "make"
    bin.install "fastp"
    pkgshare.install "testdata"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastp --version 2>&1")
    system "#{bin}/fastp", "-i", pkgshare/"testdata/R1.fq", "-o", testpath/"out.fq"
    File.exist?("out.fq")
  end
end
