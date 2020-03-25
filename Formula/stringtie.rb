class Stringtie < Formula
  # cite Pertea_2015: "https://doi.org/10.1038/nbt.3122"
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://ccb.jhu.edu/software/stringtie"
  url "https://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.6.tar.gz"
  sha256 "9dbdf01ab3282dc6eb647409920b53f8e0df45f4c45faf9d6b5ca135a3738ee8"
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
