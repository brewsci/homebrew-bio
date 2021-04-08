class Varsim < Formula
  desc "High-fidelity simulation validation framework for NGS"
  homepage "https://github.com/bioinform/varsim"
  url "https://github.com/bioinform/varsim/releases/download/v0.8.6/varsim-0.8.6.tar.gz"
  sha256 "19c35be253fda9e5799cbed123b2e34ae227499a1707e795e7c7099562023c50"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "c6b82592aa5824c0035de5ef5636f76a26985ed1e54e7f9b5b43c9438764e8ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b06e5eb42eda0e79c90354a8f7b5768c920c4c45a72a457b732f64e12d037e39"
  end

  depends_on "openjdk"

  def install
    jar = "VarSim.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "varsim"
  end

  test do
    assert_match "diploid", shell_output("#{bin}/varsim 2>&1", 1)
  end
end
