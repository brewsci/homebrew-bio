class Varsim < Formula
  desc "High-fidelity simulation validation framework for NGS"
  homepage "https://github.com/bioinform/varsim"
  url "https://github.com/bioinform/varsim/releases/download/v0.8.4/varsim-0.8.4.tar.gz"
  sha256 "36d2dd6ccd60cd97ea60fdab918d21cb520894d7d38276b837c39ef587977696"
  license "BSD-2-Clause"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "c6b82592aa5824c0035de5ef5636f76a26985ed1e54e7f9b5b43c9438764e8ea" => :catalina
    sha256 "b06e5eb42eda0e79c90354a8f7b5768c920c4c45a72a457b732f64e12d037e39" => :x86_64_linux
  end

  depends_on :java

  def install
    jar = "VarSim.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "varsim"
  end

  test do
    assert_match "diploid", shell_output("#{bin}/varsim 2>&1", 1)
  end
end
