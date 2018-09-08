class Repaq < Formula
  desc "Repack Illumina format FASTQ to a smaller binary file"
  homepage "https://github.com/OpenGene/repaq"
  url "https://github.com/OpenGene/repaq/archive/v0.2.0.tar.gz"
  sha256 "60c0a0449d45a3cd346f67cd6db93a961ff7f9d41e787f5c39834d0b1ad3a1bc"

  depends_on "zlib" unless OS.mac?

  needs :cxx11

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
