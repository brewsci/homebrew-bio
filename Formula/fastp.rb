class Fastp < Formula
  # cite Chen_2018: "https://doi.org/10.1101/274100"
  desc "Ultrafast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/v0.20.1.tar.gz"
  sha256 "e1b663717850bed7cb560c0c540e9a05dd9448ec76978faaf853a6959fd5b1b3"
  license "MIT"
  head "https://github.com/OpenGene/fastp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f693c70a18ff037dde2e745b321b2327557131c7a60be8ed3b9ee7b0fc5be140" => :catalina
    sha256 "e0425b440fdc6b152c7a5426a41a437fc58995e67b0fab29864ed896cf2cc1c6" => :x86_64_linux
  end

  uses_from_macos "zlib"

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
