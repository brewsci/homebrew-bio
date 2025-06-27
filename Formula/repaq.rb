class Repaq < Formula
  desc "Repack Illumina format FASTQ to a smaller binary file"
  homepage "https://github.com/OpenGene/repaq"
  url "https://github.com/OpenGene/repaq/archive/v0.2.0.tar.gz"
  sha256 "60c0a0449d45a3cd346f67cd6db93a961ff7f9d41e787f5c39834d0b1ad3a1bc"
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
