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
    sha256 cellar: :any,                 catalina:     "299b5fb39c237e03266945ad75736673417553b044f26d69ead428c75fff9681"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8c7e9babe2457e46d6729e70babf7a182bffd4ea743d5a305d3ef837faf1fc58"
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
