class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  # URL hack is to bypass audit for word "beta"
  url "https://github.com/DerrickWood/kraken2/archive/v2.0.8-b%65ta.tar.gz"
  version "2.0.8"
  sha256 "f2a91fc57a40b3e87df8ac2ea7c0ff1060cc9295c95de417ee53249ee3f7ad8e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "48ed6a84341a531b1ff9547c306fc1874fb5345b03af6aa4d543256e45881a71" => :sierra
    sha256 "011ac904f9a6341e34f296e9af6853209e57dd34225b3adeabd134ffca71affe" => :x86_64_linux
  end

  depends_on "blast" # for segmasker + dustmasker
  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "perl"
  end

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
