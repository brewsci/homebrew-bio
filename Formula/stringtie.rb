class Stringtie < Formula
  # cite Pertea_2015: "https://doi.org/10.1038/nbt.3122"
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://ccb.jhu.edu/software/stringtie"
  url "https://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.6.tar.gz"
  sha256 "9dbdf01ab3282dc6eb647409920b53f8e0df45f4c45faf9d6b5ca135a3738ee8"
  head "https://github.com/gpertea/stringtie.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "88efd6d81791afe33bf0bb4e70870ec99802751438dfc8aab482065025ce06d6" => :sierra
    sha256 "280961f1341325e6b86c7c02b6de900a506d5e8aa026d33cc18fff83fff003e3" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    system "make", "release"
    bin.install "stringtie"
  end

  test do
    assert_match "transcripts", shell_output("#{bin}/stringtie 2>&1", 1)
  end
end
