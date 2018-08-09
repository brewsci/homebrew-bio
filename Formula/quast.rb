class Quast < Formula
  # cite Gurevich_2013: "https://doi.org/10.1093/bioinformatics/btt086"
  # cite Mikheenko_2015: "https://doi.org/10.1093/bioinformatics/btv697"
  # cite Mikheenko_2016: "https://doi.org/10.1093/bioinformatics/btw379"
  # cite Mikheenko_2018: "https://doi.org/10.1093/bioinformatics/bty266"
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "http://quast.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/quast/quast-5.0.0.tar.gz"
  sha256 "129013967279e9bf501be67e2e59c3b8eed1de82b19163cb528aa618a21b8d73"
  head "https://github.com/ablab/quast.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "101ecf5624406959757f074218ba95ebc16a226b852f68832b0da29e0b303779" => :sierra_or_later
    sha256 "ce3487e38818178541943c3961139339cbfb6f785ffb744a0eddef8d28aabd90" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../quast.py", "../metaquast.py", "../quast-lg.py", "../icarus.py",
      "quast.py" => "quast", "metaquast.py" => "metaquast", "quast-lg.py" => "quast-lg", "icarus.py" => "icarus"
    # Compile the bundled aligner so that `brew test quast` does not fail.
    system "#{bin}/quast", "--test"
  end

  test do
    system "#{bin}/quast", "--test"
  end
end
