class Unicycler < Formula
  # cite Wick_2017: "https://doi.org/10.1371/journal.pcbi.1005595"
  include Language::Python::Virtualenv

  desc "Hybrid assembly pipeline for bacterial genomes"
  homepage "https://github.com/rrwick/Unicycler"
  url "https://github.com/rrwick/Unicycler/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "c6b04923363719d7672c8c0b39a357712328ab8471175a2f172effbd9584448e"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Unicycler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "1100ca4a35cdef3a0c7b232d8e8418ee416ef74095b8fc28f8a4fccc6e4ab7ed"
    sha256 cellar: :any, x86_64_linux: "870cda34ffc8986c8bdb1b24707da593b6ffa0675627b73db644d0c13f999b66"
  end

  depends_on "blast"
  depends_on "brewsci/bio/racon"
  depends_on "python@3.12"
  depends_on "spades"

  uses_from_macos "zlib"

  def python3
    which("python3.12")
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install_and_link buildpath
  end

  test do
    resource "short1" do
      url "https://github.com/rrwick/Unicycler/raw/main/sample_data/short_reads_1.fastq.gz"
      sha256 "a33f92fdd1999277443d1fbac66ec20caf9de5c4c0d5a7e061658397a6d538e5"
    end
    resource "short2" do
      url "https://github.com/rrwick/Unicycler/raw/main/sample_data/short_reads_2.fastq.gz"
      sha256 "0935d339c0d6194749b539dfb6abd907635a600b5116c78daa47cad9e5569125"
    end
    assert_match "usage", shell_output("#{bin}/unicycler --help")
    resources.each { |r| r.stage testpath }
    system "#{bin}/unicycler", "-1", "short_reads_1.fastq", "-2", "short_reads_2.fastq", "-o", "test"
    assert_predicate testpath/"test/assembly.gfa", :exist?
    assert_predicate testpath/"test/assembly.fasta", :exist?
  end
end
