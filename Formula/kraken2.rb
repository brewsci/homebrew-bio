class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/v2.0.6-beta.tar.gz"
  sha256 "d77db6251179c4d7e16bc9b5e5e9043d25acf81f3e32ad6eadfba829a31e1d09"

  fails_with :clang # needs openmp

  depends_on "blast" # for segmasker + dustmasker
  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "perl"
  end

  needs :cxx11

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
