class Repaq < Formula
  desc "Repack Illumina format FASTQ to a smaller binary file"
  homepage "https://github.com/OpenGene/repaq"
  url "https://github.com/OpenGene/repaq/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "19720e87ce83327d8c8de6176fa85bb32ada4d722eea86ee5210d2d55cd4e787"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "525d967c0b778978a36a7dbbc63b53f6efb49880c9316512a098c122410ff92b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42cf85aaf8f98ff155174db95052222f729058c8abcf16207f5c7dc809d52171"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "472e26133164fe39c56eda741d3b28047f2e788554b9ccaebddcc49c17935e96"
    sha256 cellar: :any,                 x86_64_linux:  "0607ec967f458facf824ffa57d86095ee173aadfca30fc99cb31c4e2f3d802ba"
  end

  uses_from_macos "zlib"

  def install
    # newer GCC needs an explicit <cstdint>; the Makefile hard-assigns CXXFLAGS
    # with ":=" so env CXXFLAGS is ignored, patch the assignment directly.
    inreplace "Makefile", "CXXFLAGS := -std=c++11", "CXXFLAGS := -std=c++11 -include cstdint"
    system "make"
    # https://github.com/OpenGene/repaq/issues/6
    bin.mkpath
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "decompress", shell_output("#{bin}/repaq --help 2>&1")
  end
end
