class Ntedit < Formula
  # cite Warren_2019: "https://doi.org/10.1093/bioinformatics/btz400"
  desc "Scalable genome assembly polishing"
  homepage "https://github.com/bcgsc/ntEdit"
  url "https://github.com/bcgsc/ntEdit/archive/v1.3.5.tar.gz"
  sha256 "bbf847bd597256f2a7f8eeaca9a61b73b7040a1aadf52252911149518819324e"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntEdit.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "c6b971225ada7472390713dfbaa78ed282516f1f3f4a070d2ec18de6f4b9415b"
    sha256 cellar: :any, x86_64_linux: "ef92eab23addd3ca6f86f76a6aa01dfc9b905d59f5cbf3d22b14f89ecad29fc5"
  end

  depends_on "gcc" if OS.mac? # needs openmp

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    system "make"
    bin.install "ntedit"
  end

  test do
    assert_match "Options", shell_output("#{bin}/ntedit --help 2>&1")
  end
end
