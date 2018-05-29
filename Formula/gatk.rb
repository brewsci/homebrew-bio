class Gatk < Formula
  # cite McKenna_2010: "https://doi.org/10.1101/gr.107524.110"
  desc "Genome Analysis Toolkit: Variant Discovery in High-Throughput Sequencing"
  homepage "https://software.broadinstitute.org/gatk/"
  url "https://github.com/broadinstitute/gatk/releases/download/4.0.5.1/gatk-4.0.5.1.zip"
  sha256 "3847f540beeb02651f0cf8f14bb0c6ed4e837f1ea73bc6d04cbe38d217c1b25f"
  head "https://github.com/broadinstitute/gatk.git"

  bottle :unneeded

  depends_on :java

  def install
    prefix.install Dir["*"]
    bin.install_symlink prefix/"gatk"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/gatk --help 2>&1", 0)
  end
end
