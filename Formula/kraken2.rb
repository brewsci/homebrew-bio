class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "5bbd79392ff7c530124986dfdfe126bf638477db94fb7a901ec2daf9261707f3"
  license "MIT"
  head "https://github.com/DerrickWood/kraken2.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54a364b5f9670acca86eda276475121d06b51aea877e184521a3a4f92559ba4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "890e1f546be6610b1dac7211aceb9a927f165646a2522626b18a507721027cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40f158613d0097f3cabff05b669b72aac25819b4ef5125bfbb67578446890a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bf9cdb39dae6e35d7fbc6165e098b483d5ce7fd3d00295fe6182beb7b8d867e"
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
