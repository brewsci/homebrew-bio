class Stringtie < Formula
  # cite Pertea_2015: "https://doi.org/10.1038/nbt.3122"
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://github.com/gpertea/stringtie"
  url "https://github.com/gpertea/stringtie/releases/download/v2.1.3b/stringtie-2.1.3b.tar.gz"
  sha256 "40df999694b77179c856af7c6fb94f2586fcf8a8ef5f68bb239f3f84bb31e4d6"
  head "https://github.com/gpertea/stringtie.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "19a315de6e4d605b7265aafdf7ac3679132c83ed13554d436a3ed2ad43217af2" => :sierra
    sha256 "d0de065c76440a908f7a77d3beb8e7edbfc24688ed89825ead5462d0dd68102c" => :x86_64_linux
  end

  uses_from_macos "zlib"

  def install
    system "make", "release"
    bin.install "stringtie"
  end

  test do
    assert_match "transcripts", shell_output("#{bin}/stringtie 2>&1", 1)
  end
end
