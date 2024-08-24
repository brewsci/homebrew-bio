class Porechop < Formula
  # cite Wick_2017: "https://doi.org/10.1099/mgen.0.000132"
  desc "Trim adapters of Oxford Nanopore sequencing reads"
  homepage "https://github.com/rrwick/Porechop"
  url "https://github.com/rrwick/Porechop/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "44b499157d933be43f702cec198d1d693dcb9276e3c545669be63c2612493299"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Porechop.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "126ed1f86d3ba023ae5b5500a22256719a8d325273ca3ecd637d918ad1f44f0c"
    sha256 cellar: :any,                 ventura:      "a7848b8f3c171559526b6664a84bedb72a746be50a38040e83073bd2a72abc90"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c538b9b7f8304ff1970f0bc9b2ee32fd87b6d6dc7441c4bee5832293f5a122d1"
  end

  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
  end

  test do
    assert_match "usage", shell_output("#{bin}/porechop --help")
  end
end
