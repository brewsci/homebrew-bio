class Kounta < Formula
  desc "Generate multi-sample k-mer count matrix"
  homepage "https://github.com/tseemann/kounta"
  url "https://github.com/tseemann/kounta/archive/v0.2.3.tar.gz"
  sha256 "adf17fb77afb66a8756d002fafc6497ac2249cb18f102d9ad8eb90851d423fb2"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "1e0eb6dbb219f19b82dc684cbef7ddcdd7ed9f5b9cb5f7b21bb253bc1e369ea1" => :catalina
    sha256 "bd468d88c9e66bb63a3fd490c30398516e1ed78b119047d33917a00a9da6bc5a" => :x86_64_linux
  end

  depends_on "kmc"
  depends_on "parallel"
  depends_on "perl" # need 5.26 or later

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kounta --version")
    assert_match "matrix", shell_output("#{bin}/kounta --help")
  end
end
