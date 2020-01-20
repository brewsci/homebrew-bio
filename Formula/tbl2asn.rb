class Tbl2asn < Formula
  desc "Automates the submission of sequence records to GenBank"
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"

  # version number is in https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/VERSIONS
  version "25.8"
  if OS.mac?
    url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha256 "d326f751784fa36b2eb46bbdb749fb17fe4ca0a5d3c859ac57397ba5b724a35a"
  elsif OS.linux?
    url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha256 "05b4cec586fab9f07926413e61bed718ab401242859ebd5e8b9b11fbd6e6c203"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fe9460e20c97aabc4f59f66aa5b72909b3d634089c04439ded94c2c68f8802ad" => :sierra
    sha256 "d56a0129f2f42bde0c2417f97c0862bd5791c0155b4a0fd93aacbc86f1d86a59" => :x86_64_linux
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
