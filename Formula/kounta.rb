class Kounta < Formula
  desc "Generate multi-sample k-mer count matrix"
  homepage "https://github.com/tseemann/kounta"
  url "https://github.com/tseemann/kounta/archive/v0.1.6.tar.gz"
  sha256 "d3b2312fd03bf39844f22c9169653f3cda10c2919c8d2f9b46f5f35dbf934c38"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fd5461142b6d7304071710d1e32acec74fede6056e31f882437cb180354d5ad" => :sierra
    sha256 "65914592c5380f403629e306fbe10cb85855a8e260f41eb2a3e889ee382065b3" => :x86_64_linux
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
