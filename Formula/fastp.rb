class Fastp < Formula
  # cite Chen_2018: "https://doi.org/10.1101/274100"
  desc "Ultrafast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/v0.14.1.tar.gz"
  sha256 "212317afee62d27a19c0bd536fa23fd68974ff9f8d25b8a0992958ed27da5728"
  head "https://github.com/OpenGene/fastp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "8e04cc8a0c2a0067710fa13a68456393026a26c84916d7660b64270de49c2396" => :sierra_or_later
    sha256 "cca5e746085309b668d76bc56ab990db77767447304bec85c3d692f666704ca5" => :x86_64_linux
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
