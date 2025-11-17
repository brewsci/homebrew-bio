class Kraken < Formula
  # cite Wood_2014: "https://doi.org/10.1186/gb-2014-15-3-r46"
  desc "Assign taxonomic labels to short DNA sequences"
  homepage "https://ccb.jhu.edu/software/kraken/"
  url "https://github.com/DerrickWood/kraken/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "73e48f40418f92b8cf036ca1da727ca3941da9b78d4c285b81ba3267326ac4ee"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/DerrickWood/kraken.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29a82231df9a99f38d4b5a91dde0ba3fc34abfedf36d87ed31f0ef62c7c239e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5c7e9640511c7f344e2f5d1f8e91ff697f353b4c2e4a9e1061d2f53b92ac97c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7fe7e001399d9a60864350858b149309f91b14e9ffb43d6a80e858b3f024406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df65bca1593f870f9450460c0d345dc8f5766bf3eba9643b02e84f5ba21a1b21"
  end

  on_macos do
    depends_on "libomp"
  end

  def install
    libexec.mkdir
    system "./install_kraken.sh", libexec
    libexec_bins = %w[kraken kraken-build kraken-filter kraken-mpa-report kraken-report kraken-translate].map do |x|
      libexec + x
    end
    bin.install_symlink(libexec_bins)
    doc.install Dir["docs/*"]
  end

  def caveats
    <<~EOS
      You must build a DB before usage. Minikraken DB can be found here:
      https://ccb.jhu.edu/software/kraken/dl/minikraken_20171019_4GB.tgz
      https://ccb.jhu.edu/software/kraken/dl/minikraken_20171019_8GB.tgz

      For more information on kraken DBs:
      https://ccb.jhu.edu/software/kraken/
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/kraken --help 2>&1")
  end
end
