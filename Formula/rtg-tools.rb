class RtgTools < Formula
  # cite Cleary_2015: "https://doi.org/10.1101/023754"
  desc "Easily manipulate and accurately compare multiple VCF files"
  homepage "https://www.realtimegenomics.com/products/rtg-tools"
  url "https://github.com/RealTimeGenomics/rtg-tools/releases/download/3.11/rtg-tools-3.11-nojre.zip"
  sha256 "f9ca3fa5a7d2c737490560970fee4cfa185490542283fb005ec77b77690c133e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "bdaf12a1b959ff8e6f0be5c76e7cae0dbf702713d3536662d624d31d14d8992a" => :sierra
    sha256 "1356b2f836c6644e4eca186f5d34346bdad080bf3c562e9f1c9af03787373ce6" => :x86_64_linux
  end

  depends_on :java

  def install
    # avoid question about sending stats back to base
    (prefix/"rtg.cfg").write "RTG_TALKBACK=false\n"
    rm "rtg.bat"
    bin.install_symlink "../rtg"
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtg version")
  end
end
