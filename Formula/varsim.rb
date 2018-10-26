class Varsim < Formula
  desc "High-fidelity simulation validation framework for NGS"
  homepage "https://github.com/bioinform/varsim"
  url "https://github.com/bioinform/varsim/releases/download/v0.8.2/varsim-0.8.2.tar.gz"
  sha256 "a41f58cc55dcda2d69ca8dabc1f50a7799b16cccaf9f34af082ed1322e1462b8"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3c85530187825523c88c8ce2aed35c5e83c090ec32a7533c7705674655ee8f75" => :sierra
    sha256 "200c268c51ed00026b58c6df95a7c0fb1e60b168a8c522eb8c18a8a8d4a03f1f" => :x86_64_linux
  end

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
