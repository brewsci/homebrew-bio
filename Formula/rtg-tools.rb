class RtgTools < Formula
  # cite Cleary_2015: "https://doi.org/10.1101/023754"
  desc "Easily manipulate and accurately compare multiple VCF files"
  homepage "https://www.realtimegenomics.com/products/rtg-tools"
  url "https://github.com/RealTimeGenomics/rtg-tools/releases/download/3.11/rtg-tools-3.11-nojre.zip"
  sha256 "f9ca3fa5a7d2c737490560970fee4cfa185490542283fb005ec77b77690c133e"
  license "BSD-2-Clause"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2c49d03dc7de14197a22c6a964ca89a941f57c7a05157919784cd6a31e4da198" => :catalina
    sha256 "ce63fdebf09a933feb1bb707d150eab6d929337353de6cf543ca1eae7f8926e7" => :x86_64_linux
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
