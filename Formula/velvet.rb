class Velvet < Formula
  # cite Zerbino_2008: "https://doi.org/10.1101/gr.074492.107"
  desc "Sequence assembler for very short reads"
  homepage "https://www.ebi.ac.uk/~zerbino/velvet/"
  url "https://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz"
  sha256 "884dd488c2d12f1f89cdc530a266af5d3106965f21ab9149e8cb5c633c977640"
  head "https://github.com/dzerbino/velvet.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2f7e5a1c844dbad804e896a9f27768cdd17b25b0c46de794449f7d44266379b2" => :sierra
    sha256 "79ad825ef586b4627de53573503b695c7a1f4167bba3a0f9058aa1d83382934e" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    args = ["LONGSEQUENCES=1", "CATEGORIES=2", "MAXKMERLENGTH=127"]
    args << "OPENMP=1" unless OS.mac?
    system "make", "velveth", "velvetg", *args
    bin.install "velveth", "velvetg"
    doc.install "Manual.pdf"
    pkgshare.install "tests", "data", "contrib"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/velveth")
    assert_match version.to_s, shell_output("#{bin}/velvetg", 1)
  end
end
