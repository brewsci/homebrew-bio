class Nxtrim < Formula
  # cite O_Connell_2014: "https://doi.org/10.1101/007666"
  desc "Trim adapters for Illumina Nextera Mate Pair libraries"
  homepage "https://github.com/sequencing/NxTrim"
  url "https://github.com/sequencing/NxTrim/archive/v0.4.3.tar.gz"
  sha256 "d216b34f92f95263882abd297332c3a6159c7f3c4165975a190891f3898391da"
  head "https://github.com/sequencing/NxTrim.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "d511ca04cfb5329414dfc6c6ddaffe42f4e3cefeb6f9ed3453725c624251dfb1" => :sierra_or_later
    sha256 "0b76900670cf28b33f0c49c46ebe432001d4d4172113155f72338c8ab130e525" => :x86_64_linux
  end

  depends_on "boost" => :build
  depends_on "zlib" unless OS.mac?

  def install
    system "make", "BOOST_ROOT=#{Formula["boost"].prefix}"
    bin.install "nxtrim"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/nxtrim 2>&1")
  end
end
