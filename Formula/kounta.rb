class Kounta < Formula
  desc "Generate multi-sample k-mer count matrix"
  homepage "https://github.com/tseemann/kounta"
  url "https://github.com/tseemann/kounta/archive/v0.2.0.tar.gz"
  sha256 "694c697b3282898adf8adfcb4a09269c5f7d5d74ff3f3108d2f283bd39ac789f"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ed7a35906564536e72d2890ae01ae7383f0ece0750eb685134bc4b717699c38" => :sierra
    sha256 "3447f8d1f06cb50ee8d701519129b35f012d4a37a6e434c832a88206c1e17017" => :x86_64_linux
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
