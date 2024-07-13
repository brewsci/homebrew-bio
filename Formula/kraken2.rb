class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "5269fa14adfb02e38c2da2e605e909a432d76c680d73e2e0e80e27ccd04d7c69"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "6673d5d0c9e848621e56caf1002e24143870968f694d989c6d6b0745ddcfa43e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "256d5d41998c45593e8797169bbcf404d3ba6a9713b9579408fef7712d84772e"
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
