class Stringtie < Formula
  # cite Pertea_2015: "https://doi.org/10.1038/nbt.3122"
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://ccb.jhu.edu/software/stringtie/"
  url "https://github.com/gpertea/stringtie/releases/download/v2.1.4/stringtie-2.1.4.tar.gz"
  sha256 "a08383edc9d41340b2c932084f64ea09280ce53f758ec3464fc9a8cf6f7eb6b1"
  head "https://github.com/gpertea/stringtie.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6a0d778a7396ca1644b4c05df3baf8beceae4204a32011044c1f1619ff20917f" => :catalina
    sha256 "2bdbcf4c21747d487ac02d2f98cb1cbc653b730e6c8bf288a87c2cf8a25ed7e0" => :x86_64_linux
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
