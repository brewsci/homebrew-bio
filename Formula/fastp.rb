class Fastp < Formula
  # cite Chen_2018: "https://doi.org/10.1101/274100"
  desc "Ultrafast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/v0.17.1.tar.gz"
  sha256 "11efb24f18fc1498ddcc82e6ed5b4b51a7b11ffa47d089b7e12dc6bf721cbb2b"
  head "https://github.com/OpenGene/fastp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6cc62927fea7ed12a6f1371281bdf8961dc583d0c1ec5be12e41acfe7d4735ab" => :sierra_or_later
    sha256 "40e309e19fff60463d19211337c95f4bc0b06e33317216edf7cc460c0525510e" => :x86_64_linux
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
