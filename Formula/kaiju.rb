class Kaiju < Formula
  # Menzel_2016: "https://doi.org/10.1038/ncomms11257"
  desc "Fast taxonomic classification of metagenomic sequencing reads"
  homepage "http://kaiju.binf.ku.dk/"
  url "https://github.com/bioinformatics-centre/kaiju/archive/v1.7.0.tar.gz"
  sha256 "96ecc84634f2a5f1440ac6d40896fdb207b1931b78629b56853ab0391e31c105"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "20762c16e53260aadd5442819643afd294d74aae65018a0c585ddd0883140978" => :sierra
    sha256 "97054f3c70423eb6a1b3ccf3427e38afb09b9eaf00dc4a18cd6f4a5ba5f46300" => :x86_64_linux
  end

  depends_on "perl"     # for kaiju-gbk2faa.pl
  depends_on "python@2" # for kaiju-convertMAR.py

  def install
    system "make", "-C", "src"

    # https://github.com/bioinformatics-centre/kaiju/issues/93
    inreplace "bin/kaiju-makedb" do |s|
      s.gsub! "$SCRIPTDIR/kaiju-convertMAR.py", pkgshare/"kaiju-convertMAR.py"
      s.gsub! "$SCRIPTDIR/kaiju-taxonlistEuk.tsv", pkgshare/"kaiju-taxonlistEuk.tsv"
    end

    pkgshare.install "bin/kaiju-convertMAR.py"
    pkgshare.install "bin/kaiju-taxonlistEuk.tsv"

    bin.install Dir["bin/*"]
  end

  def caveats
    <<~EOS
      You must build a #{name} database before usage.
      See #{opt_prefix}/README.md for details.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kaiju -h 2>&1", 1)
  end
end
