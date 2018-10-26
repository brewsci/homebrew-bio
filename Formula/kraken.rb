class Kraken < Formula
  # cite Wood_2014: "https://doi.org/10.1186/gb-2014-15-3-r46"
  desc "Assign taxonomic labels to short DNA sequences"
  homepage "https://ccb.jhu.edu/software/kraken/"
  url "https://github.com/DerrickWood/kraken/archive/v1.1.tar.gz"
  sha256 "a4ac74c54c10920f431741c80d8a172670be12c3b352912000030fb5ea4c87a7"
  head "https://github.com/DerrickWood/kraken.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "b1d19fd51e040f01a12042a24bf834b776c4efda337ec96b86372b98ea44b7f1" => :sierra
    sha256 "f58c1cb9381196f215d98da12c106455b07590608cb47960ee61b18a4702cf17" => :x86_64_linux
  end

  fails_with :clang # needs openmp
  depends_on "gcc" if OS.mac? # for openmp

  def install
    libexec.mkdir
    system "./install_kraken.sh", libexec
    libexec_bins = ["kraken", "kraken-build", "kraken-filter", "kraken-mpa-report", "kraken-report", "kraken-translate"].map { |x| libexec + x }
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
