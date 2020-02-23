class Tbl2asn < Formula
  desc "Automates the submission of sequence records to GenBank"
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"

  # version number is in https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/VERSIONS
  version "25.8"
  if OS.mac?
    url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha256 "3c266a32d4bad75648ce6d64eda31717db54f8c282097e9978ff77166fc15abc"
  elsif OS.linux?
    url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha256 "6b6d3d93240e446c0a5f06ef46312b9138944f8d364cf4d4ef53744644fc6891"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "eacd51af092160d8382f67ee09409b2dc3d978415dc9f95d2cc7f08af39b30b0" => :catalina
    sha256 "756239685f6881a204f66cbf0e4ad3edb80e97de10b26c0086d816b2c559ac2a" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "libidn"
    depends_on "zlib"
  end

  resource "doc" do
    url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/tbl2asn.txt"
    sha256 "b5e139c2a22cea4e1b5c7a063e3fb1f311d6b8802f2a8cca1433d7f16f816300"
  end

  def install
    bin.install Dir["tbl2asn*"].first => "tbl2asn"
    unless OS.mac?
      system "patchelf",
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        "--set-rpath", HOMEBREW_PREFIX/"lib",
        bin/"tbl2asn"
      # Normally we would use patchelf to make this change but it seems
      # broken for this use-case. Use the Stick of Correction instead.
      inreplace bin/"tbl2asn", "libidn.so.11", "libidn.so.12"
    end
    doc.install resource("doc")
  end

  test do
    assert_match "tbl2asn #{version}", shell_output("#{bin}/tbl2asn -")
  end
end
