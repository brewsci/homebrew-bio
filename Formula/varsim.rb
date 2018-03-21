class Varsim < Formula
  desc "High-fidelity simulation validation framework for NGS"
  homepage "https://github.com/bioinform/varsim"
  url "https://github.com/bioinform/varsim/releases/download/v0.8.2/varsim-0.8.2.tar.gz"
  sha256 "a41f58cc55dcda2d69ca8dabc1f50a7799b16cccaf9f34af082ed1322e1462b8"

  depends_on :java
  depends_on "python@2"

  def install
    jar = "VarSim.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "varsim"
  end

  test do
    assert_match "diploid", shell_output("#{bin}/varsim 2>&1", 1)
  end
end
