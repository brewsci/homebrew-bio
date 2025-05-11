class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "6feb9b1e0840a574598b84a3134a25622e5528ac6d0f4c756cdab629275d8f42"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b30330bbcf0cce0aeb27e2136333d0854bb5c1a098199d71cd845d2e924319e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "692d41e231d135a9488f145acd578de0a7a9f9cd93f057d2e4daa6b3a2bcb249"
    sha256 cellar: :any_skip_relocation, ventura:       "f96376c0f01afad2b5bc49382c5e53b40e90dc7076c5a9fca14fa4d672df055e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d192f70f159654c5b41f215324a2d305209a3b2d096269b92068b3f7e38414d3"
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
