class Kaiju < Formula
  # Menzel_2016: "https://doi.org/10.1038/ncomms11257"
  desc "Fast taxonomic classification of metagenomic sequencing reads"
  homepage "https://bioinformatics-centre.github.io/kaiju/"
  url "https://github.com/bioinformatics-centre/kaiju/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "3cc05533bf6007ffeff2d755c935354952b09a6b903c5e538dff14285b3c86e8"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4177d74dad22dcbc1ad562987899e9a62da689ebe7f7e18bac5d29bd6302d9c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f19dab2a1fb0c7191973ed2231d9b5c36c5ca955e9810ad47e1658fba1445a0d"
    sha256 cellar: :any_skip_relocation, ventura:       "c0e97b0e6960c706dbe32b352d0ba5cc3c27fcee3a3bf4857cca1749484e0080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "398d26bcfe5a59a348eb1020acd34034f430c00c90c690db94de442b7e86a1ea"
  end

  uses_from_macos "perl"
  uses_from_macos "zlib"

  def install
    system "make", "-C", "src"

    # https://github.com/bioinformatics-centre/kaiju/issues/93
    inreplace "bin/kaiju-makedb" do |s|
      s.gsub! "$SCRIPTDIR/kaiju-taxonlistEuk.tsv", pkgshare/"kaiju-taxonlistEuk.tsv"
      s.gsub! "$SCRIPTDIR/kaiju-excluded-accessions.txt", pkgshare/"kaiju-excluded-accessions.txt"
    end

    pkgshare.install "bin/kaiju-taxonlistEuk.tsv"
    pkgshare.install "bin/kaiju-excluded-accessions.txt"

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
