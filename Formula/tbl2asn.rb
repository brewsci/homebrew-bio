class Tbl2asn < Formula
  desc "Automates the submission of sequence records to GenBank"
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"

  # version number is in https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/VERSIONS
  version "25.6"
  if OS.mac?
    url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha256 "dfaedbd1ddd5e9fbf8f80e6214f48e3012498f4951e39157f3ab1926cd392c1a"
  elsif OS.linux?
    url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha256 "38560dd0764d1cfa7e139c65285b3194bacaa4bd8ac09f60f5e2bb8027cc6ca2"
  end
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "74f640b3672870fdd877329a1d15243759ee0f3c13583fbdcff08aaa6e330f9c" => :sierra
    sha256 "f056132ec96e262ad8bd7cac84d46eea67d6dd39b7e466409016b42e00304615" => :x86_64_linux
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
