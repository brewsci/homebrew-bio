class Varsim < Formula
  desc "High-fidelity simulation validation framework for NGS"
  homepage "https://github.com/bioinform/varsim"
  url "https://github.com/bioinform/varsim/releases/download/v0.8.6/varsim-0.8.6.tar.gz"
  sha256 "19c35be253fda9e5799cbed123b2e34ae227499a1707e795e7c7099562023c50"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "859f4d7fea5f23d2aad2a418a0fd05544541f1bc7d6808557be8e910d2f56b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3e6cd67468b26c7346146c52dee3f8568ffe58b47b0c3d4510a6672afd60aabe"
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
