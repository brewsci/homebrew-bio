class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "5269fa14adfb02e38c2da2e605e909a432d76c680d73e2e0e80e27ccd04d7c69"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "88f2cfc70b244a8bd65837cc4c58e6b0043ce25e1e16f2178434871b4a193a1f"
    sha256 cellar: :any_skip_relocation, ventura:      "51f5be2bc4fe02609a12571a389cad7eae91e72776c794c0698d86948e512834"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c07bc66da3cbb7d716327f62c5e16ec4944f363a7a18a64dc6424197dcce6fbb"
  end

  depends_on "blast" # for segmasker + dustmasker

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    libexec.mkdir
    system "./install_kraken2.sh", libexec
    libexec_bins = ["kraken2", "kraken2-build", "kraken2-inspect"].map { |x| libexec + x }
    bin.install_symlink(libexec_bins)
    doc.install Dir["docs/*"]
  end

  def caveats
    <<~EOS
      You must build a Kraken2 database before usage.
      See #{HOMEBREW_PREFIX}/share/doc/kraken2/MANUAL.markdown for details.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kraken2 --version 2>&1")
  end
end
