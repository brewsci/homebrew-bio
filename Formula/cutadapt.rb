class Cutadapt < Formula
  include Language::Python::Virtualenv
  # cite Martin_2011: "https://doi.org/10.14806/ej.17.1.200"
  desc "Removes adapter sequences, primers, and poly-A tails"
  homepage "https://github.com/marcelm/cutadapt"
  url "https://github.com/marcelm/cutadapt.git",
    :tag      => "v2.10",
    :revision => "9ce76e87d2f96c5369b054dbbd6ad83fa0c15f34"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f5cd26d5527d8f47fd1ffceee6ad9bc2802f613b48dff34e0be343bf1c912fc1" => :mojave
    sha256 "3c3650c892ef68f718e2662cb90104ea4a25d874c15de7bc8a8174c10cd21781" => :x86_64_linux
  end

  depends_on "python@3.8"

  resource "cython" do
    url "https://files.pythonhosted.org/packages/source/C/Cython/Cython-0.29.21.tar.gz"
    sha256 "e57acb89bd55943c8d8bf813763d20b9099cc7165c0f16b707631a7654be9cad"
  end

  resource "dnaio" do
    url "https://files.pythonhosted.org/packages/source/d/dnaio/dnaio-0.4.2.tar.gz"
    sha256 "fa55a45bfd5d9272409b714158fb3a7de5dceac1034a0af84502c7f503ee84f8"
  end

  resource "xopen" do
    url "https://files.pythonhosted.org/packages/source/x/xopen/xopen-0.8.4.tar.gz"
    sha256 "dcd8f5ef5da5564f514a990573a48a0c347ee1fdbb9b6374d31592819868f7ba"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "interleaved", shell_output("#{bin}/cutadapt -h 2>&1")
  end
end
