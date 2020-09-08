class Flye < Formula
  include Language::Python::Virtualenv

  # cite Kolmogorov_2018: "https://doi.org/10.1101/247148"
  desc "Fast and accurate de novo assembler for single molecule sequencing reads"
  homepage "https://github.com/fenderglass/Flye"
  url "https://github.com/fenderglass/Flye/archive/2.8-1.tar.gz"
  version "2.8"
  sha256 "bb9f7e38812f7f5eacae20c15c675babeebd640f4f030f5d9a07b052466ebf34"
  license "BSD-3-Clause"
  head "https://github.com/fenderglass/Flye.git", branch: "flye"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0c461022fa8f1b41ac6ea79bb320a913c09da9cb89930c912e0be0edddf253c7" => :catalina
    sha256 "1f0c23f01533968deab9bc997bd116cea9a11b1941f325981370d9899815cc83" => :x86_64_linux
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
