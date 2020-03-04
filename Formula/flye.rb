class Flye < Formula
  include Language::Python::Virtualenv

  # cite Kolmogorov_2018: "https://doi.org/10.1101/247148"
  desc "Fast and accurate de novo assembler for single molecule sequencing reads"
  homepage "https://github.com/fenderglass/Flye"
  url "https://github.com/fenderglass/Flye/archive/2.7.tar.gz"
  sha256 "4d595f53bd68c820b43509ce6ee7284847237e70a3b4bc16c57170bb538d3947"
  head "https://github.com/fenderglass/Flye.git", :branch => "flye"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9c0d8e1bb12f0bba3837437c77fb56501c74509249c69ae56063659e4a2e377b" => :catalina
    sha256 "354c486e6585dbb1b73573cabc47dcf4e5bc8fc485f6b27016dc9eace1be0ad3" => :x86_64_linux
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
