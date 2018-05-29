class Stringtie < Formula
  # cite Pertea_2015: "https://doi.org/10.1038/nbt.3122"
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://ccb.jhu.edu/software/stringtie"
  url "https://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.4d.tar.gz"
  sha256 "b1962d0108146ce7fea39d069b5e5de918e0e21daef9e1425ec9b778094d6ae6"
  head "https://github.com/gpertea/stringtie.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "3961cac0570c7d83e9fbe4ea69dbb8ede22973bb4aa1fc016d91bc5f048c8848" => :sierra_or_later
    sha256 "feba49badea9c8672d70e6ac9452f8831fe0b3f4254d6d185de3bb1830792eeb" => :x86_64_linux
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "3961cac0570c7d83e9fbe4ea69dbb8ede22973bb4aa1fc016d91bc5f048c8848" => :sierra_or_later
    sha256 "feba49badea9c8672d70e6ac9452f8831fe0b3f4254d6d185de3bb1830792eeb" => :x86_64_linux
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
