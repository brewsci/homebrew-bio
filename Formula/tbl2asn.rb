class Tbl2asn < Formula
  desc "Automates the submission of sequence records to GenBank"
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"

  # version number is in https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/VERSIONS
  version "25.7"
  if OS.mac?
    url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha256 "8dab2f4ff804ad0678de1eebbdd4a3515b0740f5f2116bf91d55cc808f520cbc"
  elsif OS.linux?
    url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha256 "1f41acb9eacd6e0fa78657b17727b8f94d97490617563686d28b3f6c24d39117"
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
