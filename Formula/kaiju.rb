class Kaiju < Formula
  # Menzel_2016: "https://doi.org/10.1038/ncomms11257"
  desc "Fast taxonomic classification of metagenomic sequencing reads"
  homepage "https://bioinformatics-centre.github.io/kaiju/"
  url "https://github.com/bioinformatics-centre/kaiju/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "3cc05533bf6007ffeff2d755c935354952b09a6b903c5e538dff14285b3c86e8"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "2205484050950d1feb85433a32010d5670b99abda4e8eb6316999b8c02733f49"
    sha256 cellar: :any_skip_relocation, ventura:      "39fe014d5e16a725740d6b6d21b75bf7b68c78b77c359d558b7ea3eac44eef7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f54e1a2babe2d733e3a3149461f6f1808a075a219bd911cfeaeee2f4659b45bf"
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
