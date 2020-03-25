class Fastp < Formula
  # cite Chen_2018: "https://doi.org/10.1101/274100"
  desc "Ultrafast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/v0.20.0.tar.gz"
  sha256 "8d751d2746db11ff233032fc49e3bcc8b53758dd4596fdcf4b4099a4d702ac22"
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
