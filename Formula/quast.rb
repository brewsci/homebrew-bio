class Quast < Formula
  # cite Gurevich_2013: "https://doi.org/10.1093/bioinformatics/btt086"
  # cite Mikheenko_2015: "https://doi.org/10.1093/bioinformatics/btv697"
  # cite Mikheenko_2016: "https://doi.org/10.1093/bioinformatics/btw379"
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "http://cab.spbu.ru/software/quast/"
  url "https://downloads.sourceforge.net/project/quast/quast-4.6.3.tar.gz"
  sha256 "c00ef637282207dcad05de9503c704bc6cc69eea4fb52f7802fd8566afa31c4e"
  head "https://github.com/ablab/quast.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "101ecf5624406959757f074218ba95ebc16a226b852f68832b0da29e0b303779" => :sierra_or_later
    sha256 "ce3487e38818178541943c3961139339cbfb6f785ffb744a0eddef8d28aabd90" => :x86_64_linux
  end

  depends_on "matplotlib"

  stable do
    depends_on "e-mem"
  end

  def install
    # Remove the precompiled E-MEM binary.
    rm_f "quast_libs/MUMmer/e-mem-osx"
    prefix.install Dir["*"]
    bin.install_symlink "../quast.py", "../metaquast.py", "../icarus.py",
      "quast.py" => "quast", "metaquast.py" => "metaquast", "icarus.py" => "icarus"
    # Compile the bundled aligner so that `brew test quast` does not fail.
    system "#{bin}/quast", "--test"
  end

  test do
    system "#{bin}/quast", "--test"
  end
end
