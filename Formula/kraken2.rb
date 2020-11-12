class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/v2.1.1.tar.gz"
  sha256 "8f3e928cdb32b9e8e6f55b44703d1557b2a5fc3f30f63e8d16e465e19a81dee4"
  license "MIT"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "b89edf3c230158ea9ac3df0f5ce37b4b44a615577940f375926839f8bd267dad" => :catalina
    sha256 "0145a2ff1d8ba837b22167cf8c1dcdc04ae13c1114ad7f7df2dfb256dd2c2857" => :x86_64_linux
  end

  depends_on "blast" # for segmasker + dustmasker
  depends_on "gcc" if OS.mac? # needs openmp

  uses_from_macos "perl"

  fails_with :clang # needs openmp

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
