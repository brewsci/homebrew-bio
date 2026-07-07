class Repaq < Formula
  desc "Repack Illumina format FASTQ to a smaller binary file"
  homepage "https://github.com/OpenGene/repaq"
  url "https://github.com/OpenGene/repaq/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "19720e87ce83327d8c8de6176fa85bb32ada4d722eea86ee5210d2d55cd4e787"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "e958a6d2b6510627d73c6bd60f4bdb992e7214d3ff92e1d54fa49a80bf0e9924"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4e291d5df6f67232d7bc2616b3b2f90f22c3960d56b006c46bcee37df383bbb7"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    # https://github.com/OpenGene/repaq/issues/6
    bin.mkpath
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "decompress", shell_output("#{bin}/repaq --help 2>&1")
  end
end
