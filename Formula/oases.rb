class Oases < Formula
  # cite Schulz_2012: "https://doi.org/10.1093/bioinformatics/bts094"
  desc "De novo transcriptome assembler for very short reads"
  homepage "https://www.ebi.ac.uk/~zerbino/oases/"
  url "https://www.ebi.ac.uk/~zerbino/oases/oases_0.2.08.tgz"
  sha256 "a90d469bd19d355edf6193dcf321f77216389d2831a849d4c151c1c0c771ab36"
  head "https://github.com/dzerbino/oases"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "79b961f7f73835ea2ae13a7312bfd84f18c0af317de31659a475e27048d946c9" => :sierra
    sha256 "0efc1b966ea6e662d6994762b3d20d76d1278965e666fa7f06ccb25ac0d1053b" => :x86_64_linux
  end

  depends_on "python@2"
  depends_on "velvet"
  depends_on "zlib" unless OS.mac?

  resource "velvet" do
    url "https://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz"
    sha256 "884dd488c2d12f1f89cdc530a266af5d3106965f21ab9149e8cb5c633c977640"
  end

  def install
    ENV.deparallelize

    resource("velvet").stage do
      mkdir buildpath/"velvet"
      cp_r ".", buildpath/"velvet"
    end

    args = ["LONGSEQUENCES=1", "CATEGORIES=2", "MAXKMERLENGTH=127"]
    args << "OPENMP=1" unless OS.mac?

    # don't want to install LaTeX just to make the binary
    inreplace "Makefile", "oases doc", "oases"

    # needs access to .o files from our resource
    inreplace "Makefile", "VELVET_DIR=../velvet", "VELVET_DIR=./velvet\n.PHONY: velvet"

    system "make", *args

    bin.install "oases", "scripts/oases_pipeline.py"
  end

  test do
    assert_match "Zerbino", shell_output("#{bin}/oases 2>&1", 1)
    assert_match "KMERGE", shell_output("#{bin}/oases_pipeline.py 2>&1", 1)
  end
end
