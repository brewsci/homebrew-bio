class Fastp < Formula
  # cite Chen_2018: "https://doi.org/10.1101/274100"
  desc "Ultrafast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/v0.19.8.tar.gz"
  sha256 "69df61e74e85b6ceb872899150113d67fcc181d9a86dec67d997238d2b458932"
  head "https://github.com/OpenGene/fastp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e6c920a65264bc1d908e32bc7e02e12ab120f8657fba743c202871e012bac12f" => :sierra
    sha256 "7efc6449f8020d3e5c64af330c22d658b121d719fc33cee86b5b358295e47ea4" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

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
