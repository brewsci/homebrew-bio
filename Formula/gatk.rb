class Gatk < Formula
  # cite McKenna_2010: "https://doi.org/10.1101/gr.107524.110"
  desc "Genome Analysis Toolkit: Variant Discovery in High-Throughput Sequencing"
  homepage "https://software.broadinstitute.org/gatk/"
  url "https://github.com/broadinstitute/gatk/releases/download/4.1.2.0/gatk-4.1.2.0.zip"
  sha256 "ffc5f9b3d4b35772ee5dac3060b59dc657f30e830745160671d84d732c30dc65"
  head "https://github.com/broadinstitute/gatk.git"

  bottle :unneeded

  depends_on :java
  depends_on "python@2" unless OS.mac?

  def install
    prefix.install Dir["*"]
    bin.install_symlink prefix/"gatk"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/gatk --help 2>&1")
  end
end
