class Stringtie < Formula
  # cite Pertea_2015: "https://doi.org/10.1038/nbt.3122"
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://ccb.jhu.edu/software/stringtie/"
  url "https://github.com/gpertea/stringtie/releases/download/v2.1.4/stringtie-2.1.4.tar.gz"
  sha256 "a08383edc9d41340b2c932084f64ea09280ce53f758ec3464fc9a8cf6f7eb6b1"
  license "MIT"
  head "https://github.com/gpertea/stringtie.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f3bd8bfd0a67b5e281367af47bbbe2edac651bcdfd0fa1a5fb4b59ecbb3fa86d" => :catalina
    sha256 "2caf601a36af8448066dac8da2c64947398ba12e8716039fd8817e146f584ec5" => :x86_64_linux
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
