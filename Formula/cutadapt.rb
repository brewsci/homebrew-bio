class Cutadapt < Formula
  include Language::Python::Virtualenv
  # cite Martin_2011: "https://doi.org/10.14806/ej.17.1.200"
  desc "Removes adapter sequences, primers, and poly-A tails"
  homepage "https://github.com/marcelm/cutadapt"
  url "https://github.com/marcelm/cutadapt.git",
    tag:      "v2.10",
    revision: "9ce76e87d2f96c5369b054dbbd6ad83fa0c15f34"
  license "MIT"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "5f6a49a7ff02dd80c1945a436a85ad82bfc94983726bfc38fa22f5cf7ef39d28" => :catalina
    sha256 "58bc4e0007eafa31bb2d8928f17a7616fca976e0c1e2dfaf5043ab9d491194f0" => :x86_64_linux
  end

  depends_on "python@3.8"

  resource "cython" do
    url "https://files.pythonhosted.org/packages/6c/9f/f501ba9d178aeb1f5bf7da1ad5619b207c90ac235d9859961c11829d0160/Cython-0.29.21.tar.gz"
    sha256 "e57acb89bd55943c8d8bf813763d20b9099cc7165c0f16b707631a7654be9cad"
  end

  resource "dnaio" do
    url "https://files.pythonhosted.org/packages/be/46/4aebdff29822d98010b2b6b5b50f690e9a804cbd072787e2642b43e7f3f3/dnaio-0.4.2.tar.gz"
    sha256 "fa55a45bfd5d9272409b714158fb3a7de5dceac1034a0af84502c7f503ee84f8"
  end

  resource "xopen" do
    url "https://files.pythonhosted.org/packages/db/0d/333b436166ad8f05a6303df5258efb7aed127a11488151b07a1d135400b5/xopen-0.8.4.tar.gz"
    sha256 "dcd8f5ef5da5564f514a990573a48a0c347ee1fdbb9b6374d31592819868f7ba"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "interleaved", shell_output("#{bin}/cutadapt -h 2>&1")
  end
end
