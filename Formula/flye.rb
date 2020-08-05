class Flye < Formula
  include Language::Python::Virtualenv

  # cite Kolmogorov_2018: "https://doi.org/10.1101/247148"
  desc "Fast and accurate de novo assembler for single molecule sequencing reads"
  homepage "https://github.com/fenderglass/Flye"
  url "https://github.com/fenderglass/Flye/archive/2.8-1.tar.gz"
  version "2.8-1"
  sha256 "bb9f7e38812f7f5eacae20c15c675babeebd640f4f030f5d9a07b052466ebf34"
  head "https://github.com/fenderglass/Flye.git", branch: "flye"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fc4bf0891ac1f34c951b1418f95cbc8d565aa1cce6f26d63dda9e7a9fd7f3e5e" => :catalina
    sha256 "cba8b65c9b9f81a59d6cd455557fe357a305a6a842ee38745c81fc283d4a2473" => :x86_64_linux
  end

  depends_on "python@3.8"

  def install
    # Uses internal parallelization for builds
    ENV.deparallelize
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flye --version")
  end
end
