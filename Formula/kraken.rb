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
    sha256 cellar: :any_skip_relocation, catalina:     "fcefe1f392f6c3e9821b24cd8d096c90e8348a25fd577bfecdf507ff863462ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a4533e0f5e6dda9546b71f59ce77653f838f9aa59468ca1f6730f838a966523b"
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
