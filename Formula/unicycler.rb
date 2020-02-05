class Unicycler < Formula
  # cite Wick_2017: "https://doi.org/10.1371/journal.pcbi.1005595"
  desc "Hybrid assembly pipeline for bacterial genomes"
  homepage "https://github.com/rrwick/Unicycler"
  url "https://github.com/rrwick/Unicycler/archive/v0.4.8.tar.gz"
  sha256 "e948871e4de9db5964c9ca6f8f877c3cbe6a46f62052dfab52ffe0f45bbbd203"
  head "https://github.com/rrwick/Unicycler/releases"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "8ce5a702a13ed9a9948cc93bc3e56a09d8f418181d046f815e1f5c3fed5b9773" => :sierra
    sha256 "aa9986644891bee7f1a3196515f88b8f9e3c84968f412524ca552d968a403063" => :x86_64_linux
  end

  depends_on "ale"
  depends_on "blast"
  depends_on "bowtie2"
  depends_on "gcc@9" if OS.linux?
  depends_on "pilon"
  depends_on "python"
  depends_on "racon"
  depends_on "samtools"
  depends_on "spades"

  fails_with :gcc => "5"  
  fails_with :gcc => "6"  
  fails_with :gcc => "7"  
  fails_with :gcc => "8"  

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}", "--makeargs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unicycler --version 2>&1")
    assert_match "usage", shell_output("#{bin}/unicycler --help")
  end
end
