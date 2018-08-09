class Quast < Formula
  # cite Gurevich_2013: "https://doi.org/10.1093/bioinformatics/btt086"
  # cite Mikheenko_2015: "https://doi.org/10.1093/bioinformatics/btv697"
  # cite Mikheenko_2016: "https://doi.org/10.1093/bioinformatics/btw379"
  # cite Mikheenko_2018: "https://doi.org/10.1093/bioinformatics/bty266"
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "https://quast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quast/quast-5.0.0.tar.gz"
  sha256 "129013967279e9bf501be67e2e59c3b8eed1de82b19163cb528aa618a21b8d73"
  head "https://github.com/ablab/quast.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "4a0b5774de1fff664631a6864bd1efb5b380df4a303ab811ea876e9e45d5536e" => :sierra_or_later
    sha256 "f28944d4ac6776b635320c3674b9d7c88b1788e423b484938a0b915a723fdfea" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?
  depends_on "python"

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../quast.py", "../metaquast.py", "../quast-lg.py", "../icarus.py",
      "quast.py" => "quast", "metaquast.py" => "metaquast", "quast-lg.py" => "quast-lg", "icarus.py" => "icarus"
    inreplace "#{bin}/../quast.py", "#!/usr/bin/env python", "#!/usr/bin/env python3"
    inreplace "#{bin}/../metaquast.py", "#!/usr/bin/env python", "#!/usr/bin/env python3"
    inreplace "#{bin}/../icarus.py", "#!/usr/bin/env python", "#!/usr/bin/env python3"

    # Compile the bundled aligner so that `brew test quast` does not fail.
    system "#{bin}/quast", "--test"
  end

  test do
    system "#{bin}/quast", "--test"
  end
end
