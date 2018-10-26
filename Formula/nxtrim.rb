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
    sha256 "1a1af7b998b50d4f788d0096190ff96825131ad4117da8e02e5dd3b8c0b1a198" => :sierra
    sha256 "4a60e1b58c0ed93be841ea2f25c7046dc57170812c63fc5de813af55b9d3c094" => :x86_64_linux
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
