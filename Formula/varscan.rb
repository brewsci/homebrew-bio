class Varscan < Formula
  # cite Koboldt_2012: "https://doi.org/10.1101/gr.129684.111"
  desc "Variant detection in massively parallel sequencing data"
  homepage "https://dkoboldt.github.io/varscan/"
  url "https://github.com/dkoboldt/varscan/raw/master/VarScan.v2.4.3.jar"
  sha256 "dc0e908ebe6a429fdd2d0f80f26c428cfc71f65429dc1816d41230b649168ff3"

  bottle :unneeded

  depends_on :java

  def install
    jar = "VarScan.v#{version}.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "varscan"
  end

  test do
    assert_match "somatic", shell_output("#{bin}/varscan 2>&1")
    assert_match "min-coverage", shell_output("#{bin}/varscan filter -h 2>&1")
  end
end
