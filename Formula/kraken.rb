class Kraken < Formula
  # cite Wood_2014: "https://doi.org/10.1186/gb-2014-15-3-r46"
  desc "Assign taxonomic labels to short DNA sequences"
  homepage "https://ccb.jhu.edu/software/kraken/"
  url "https://github.com/DerrickWood/kraken/archive/v1.1.1.tar.gz"
  sha256 "73e48f40418f92b8cf036ca1da727ca3941da9b78d4c285b81ba3267326ac4ee"
  head "https://github.com/DerrickWood/kraken.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fcefe1f392f6c3e9821b24cd8d096c90e8348a25fd577bfecdf507ff863462ef" => :catalina
    sha256 "a4533e0f5e6dda9546b71f59ce77653f838f9aa59468ca1f6730f838a966523b" => :x86_64_linux
  end

  depends_on "gcc" if OS.mac? # needs openmp

  fails_with :clang # needs openmp

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
