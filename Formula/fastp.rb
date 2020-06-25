class Fastp < Formula
  # cite Chen_2018: "https://doi.org/10.1101/274100"
  desc "Ultrafast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/v0.20.1.tar.gz"
  sha256 "e1b663717850bed7cb560c0c540e9a05dd9448ec76978faaf853a6959fd5b1b3"
  head "https://github.com/OpenGene/fastp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "93d1c52a97cd5aeac01e2edf299aa49fd1a28b37c42d9ba4cb2044814e6f9156" => :sierra
    sha256 "94b2ab898bdd7dba321a0ab10ea594b19057575683f1b5fd53cf23166876d8a0" => :x86_64_linux
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
