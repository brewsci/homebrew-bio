class Kaiju < Formula
  # Menzel_2016: "https://doi.org/10.1038/ncomms11257"
  desc "Fast taxonomic classification of metagenomic sequencing reads"
  homepage "http://kaiju.binf.ku.dk/"
  url "https://github.com/bioinformatics-centre/kaiju/archive/v1.7.0.tar.gz"
  sha256 "96ecc84634f2a5f1440ac6d40896fdb207b1931b78629b56853ab0391e31c105"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "4b82eb52bd366a066ac477f1b45c2f7c36c160d7856384ffea34cec8027e8558" => :sierra
    sha256 "47579c356dd649d72a3b4ed0d4739c17669911f5cd8b2f842e5b48eaf5512835" => :x86_64_linux
  end

  depends_on "perl" # for kaiju-gbk2faa.pl

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
