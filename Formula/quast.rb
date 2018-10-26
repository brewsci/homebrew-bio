class Quast < Formula
  # cite Gurevich_2013: "https://doi.org/10.1093/bioinformatics/btt086"
  # cite Mikheenko_2015: "https://doi.org/10.1093/bioinformatics/btv697"
  # cite Mikheenko_2016: "https://doi.org/10.1093/bioinformatics/btw379"
  # cite Mikheenko_2018: "https://doi.org/10.1093/bioinformatics/bty266"
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "https://quast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quast/quast-5.0.1.tar.gz"
  sha256 "ec79e229e924b76535534375b3cf1c55d0fbc9b44d2795eaf1a65037ea3e5bb0"
  head "https://github.com/ablab/quast.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "21869dc7e0e5e6f11f07cf56aa89af5f90b61b9f73eb50d9e91918d258fd0057" => :sierra
    sha256 "30a020e5a22e32289e16cb35e0dc2659970f50153f7bc46cb096a10ce344152f" => :x86_64_linux
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
