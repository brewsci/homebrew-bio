class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  # URL hack is to bypass audit for word "beta"
  url "https://github.com/DerrickWood/kraken2/archive/v2.0.9-b%65ta.tar.gz"
  sha256 "0287cf4df4b5d5511a9132d9ab37a8d76864bae445579efb9cb76db7e9c09eba"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "43156e8e27f5e6bb459d6c8ba42cfc6eca0d18dcf8a03162413e98288b2f716d" => :sierra
    sha256 "f0aecc6bc527bb7718874b2852e7829fb7a53401df2555f6009c8d6b915e864f" => :x86_64_linux
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
