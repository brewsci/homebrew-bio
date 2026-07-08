class Kaiju < Formula
  # Menzel_2016: "https://doi.org/10.1038/ncomms11257"
  desc "Fast taxonomic classification of metagenomic sequencing reads"
  homepage "https://bioinformatics-centre.github.io/kaiju/"
  url "https://github.com/bioinformatics-centre/kaiju/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "8d6d10c583799b040b77f28907c6b554363199e912681b3007b93ae7d817d172"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95483bf34ab62e137dd6909e87074c02f0701bfc5c9938e81076f4cae80b5b9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da2c27cc3499dd3504f46d3db2cd915ab0eccee7885b813d0ee1df9c0975ee5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e1f398fb5544b735a5fc0315b0b13bde68e7e14839829ef5466a051ff654777"
    sha256 cellar: :any,                 x86_64_linux:  "dceaeb204ee76010008aa768c637e8a1e0feb0a07a0beca7d8d8bbe0f5c3c7b6"
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
