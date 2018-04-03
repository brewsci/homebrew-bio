class RtgTools < Formula
  # cite Cleary_2015: "https://doi.org/10.1101/023754"
  desc "Easily manipulate and accurately compare multiple VCF files"
  homepage "https://www.realtimegenomics.com/products/rtg-tools"
  url "https://github.com/RealTimeGenomics/rtg-tools/releases/download/3.9/rtg-tools-3.9-nojre.zip"
  sha256 "2c5f25ab96e4b948ca0665958635ab03255c343e008d9fab0b969246c49dba3f"

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
