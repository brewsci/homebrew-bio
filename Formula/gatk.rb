class Gatk < Formula
  # cite McKenna_2010: "https://doi.org/10.1101/gr.107524.110"
  desc "Genome Analysis Toolkit: Variant Discovery in High-Throughput Sequencing"
  homepage "https://software.broadinstitute.org/gatk/"
  url "https://github.com/broadinstitute/gatk/releases/download/4.0.1.2/gatk-4.0.1.2.zip"
  sha256 "d667c08ec44f4dc2029d00ca16cfcfe7850ae9bfdcdd6e35f3048b8e7e83647b"
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
