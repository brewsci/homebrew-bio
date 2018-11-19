class Gatk < Formula
  # cite McKenna_2010: "https://doi.org/10.1101/gr.107524.110"
  desc "Genome Analysis Toolkit: Variant Discovery in High-Throughput Sequencing"
  homepage "https://software.broadinstitute.org/gatk/"
  url "https://github.com/broadinstitute/gatk/releases/download/4.0.11.0/gatk-4.0.11.0.zip"
  sha256 "5ee23159be7c65051335ac155444c6a49c4d8e3515d4227646c0686819934536"
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
