class Gatk < Formula
  # cite McKenna_2010: "https://doi.org/10.1101/gr.107524.110"
  desc "Genome Analysis Toolkit: Variant Discovery in High-Throughput Sequencing"
  homepage "https://software.broadinstitute.org/gatk/"
  url "https://github.com/broadinstitute/gatk/releases/download/4.0.2.1/gatk-4.0.2.1.zip"
  sha256 "b8f6f2d39a5400b00f6430b4474df0ce3c36b4ddfd10e6e7a03537e87e9c3b76"
  head "https://github.com/broadinstitute/gatk.git"

  bottle :unneeded

  depends_on :java
  depends_on "python@2"

  def install
    prefix.install Dir["*"]
    bin.install_symlink prefix/"gatk"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/gatk --help 2>&1")
    assert_match "GATK", shell_output("#{bin}/gatk --list 2>&1")
  end
end
