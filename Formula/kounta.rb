class Kounta < Formula
  desc "Generate multi-sample k-mer count matrix"
  homepage "https://github.com/tseemann/kounta"
  url "https://github.com/tseemann/kounta/archive/v0.2.0.tar.gz"
  sha256 "694c697b3282898adf8adfcb4a09269c5f7d5d74ff3f3108d2f283bd39ac789f"

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
