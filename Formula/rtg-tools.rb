class RtgTools < Formula
  # cite Cleary_2015: "https://doi.org/10.1101/023754"
  desc "Easily manipulate and accurately compare multiple VCF files"
  homepage "https://www.realtimegenomics.com/products/rtg-tools"
  url "https://github.com/RealTimeGenomics/rtg-tools/releases/download/3.9/rtg-tools-3.9-nojre.zip"
  sha256 "2c5f25ab96e4b948ca0665958635ab03255c343e008d9fab0b969246c49dba3f"

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
