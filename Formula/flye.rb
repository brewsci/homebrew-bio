class Flye < Formula
  include Language::Python::Virtualenv

  # cite Kolmogorov_2018: "https://doi.org/10.1101/247148"
  desc "Fast and accurate de novo assembler for single molecule sequencing reads"
  homepage "https://github.com/fenderglass/Flye"
  url "https://github.com/fenderglass/Flye/archive/2.6.tar.gz"
  sha256 "5bdc44b84712794fa4264eed690d8c65c0d72f495c7bbf2cd15b634254809131"
  revision 1
  head "https://github.com/fenderglass/Flye.git", :branch => "flye"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "125848c78a924e0a36c115b7dad48647c59590de0755a2362ee13164b2c3d6f2" => :sierra
    sha256 "075d6ae3911c50b62d32d883903ee4595cf208e396af5155e2266e88e243ba6d" => :x86_64_linux
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage", shell_output("#{bin}/flye --help")
  end
end
