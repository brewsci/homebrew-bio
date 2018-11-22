class Quast < Formula
  # cite Gurevich_2013: "https://doi.org/10.1093/bioinformatics/btt086"
  # cite Mikheenko_2015: "https://doi.org/10.1093/bioinformatics/btv697"
  # cite Mikheenko_2016: "https://doi.org/10.1093/bioinformatics/btw379"
  # cite Mikheenko_2018: "https://doi.org/10.1093/bioinformatics/bty266"
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "https://quast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quast/quast-5.0.2.tar.gz"
  sha256 "cdb8f83e20cc38f218ff7172b454280fcb1c7e2dff74e1f8618cacc53d46b48e"
  head "https://github.com/ablab/quast.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "96cbef2a8207cb7e5335482f745ef619ceca992729d3ad853495bb2e396700d2" => :sierra
    sha256 "8a091a5df4a4895c1c3de153adaeb27473d72c6693855214bc648a9f3a3bff59" => :x86_64_linux
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
