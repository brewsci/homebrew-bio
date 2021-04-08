class Flye < Formula
  include Language::Python::Virtualenv

  # cite Kolmogorov_2018: "https://doi.org/10.1101/247148"
  desc "De novo assembler for single molecule sequencing reads using repeat graphs"
  homepage "https://github.com/fenderglass/Flye"
  url "https://github.com/fenderglass/Flye/archive/2.8.3.tar.gz"
  sha256 "070f9fbee28eef8e8f87aaecc048053f50a8102a3715e71b16c9c46819a4e07c"
  license "BSD-3-Clause"
  head "https://github.com/fenderglass/Flye.git", branch: "flye"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "3af2356ee422f2dd8f7c2610157d1c5352c71f03049b59bbbfd0a5f7707a59cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7f3794f7718a3aff68894a45d0c4431494021382506a72d948021fe88451f0b8"
  end

  depends_on "python@3.9"

  def install
    # Uses internal parallelization for builds
    ENV.deparallelize
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flye --version")
  end
end
