class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/v2.1.1.tar.gz"
  sha256 "8f3e928cdb32b9e8e6f55b44703d1557b2a5fc3f30f63e8d16e465e19a81dee4"
  license "MIT"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any, catalina:     "8e469574030fe11f7076f10ee76486f6b7625541cfb0c3c03002c8122651488b"
    sha256 cellar: :any, x86_64_linux: "0a75134a1be173c1472899b6714aa5a31bc03a12b64fe20c6817e4b64e9b2442"
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
