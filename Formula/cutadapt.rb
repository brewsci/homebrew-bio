class Cutadapt < Formula
  include Language::Python::Virtualenv
  # cite Martin_2011: "https://doi.org/10.14806/ej.17.1.200"
  desc "Removes adapter sequences, primers, and poly-A tails"
  homepage "https://github.com/marcelm/cutadapt"
  url "https://github.com/marcelm/cutadapt.git",
    :tag      => "v2.6",
    :revision => "1aceac4cdd61dd8b30d797e7ae0a5d76bacf5b33"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f5cd26d5527d8f47fd1ffceee6ad9bc2802f613b48dff34e0be343bf1c912fc1" => :mojave
    sha256 "3c3650c892ef68f718e2662cb90104ea4a25d874c15de7bc8a8174c10cd21781" => :x86_64_linux
  end

  depends_on "python"

  resource "cython" do
    url "https://files.pythonhosted.org/packages/source/C/Cython/Cython-0.29.13.tar.gz"
    sha256 "c29d069a4a30f472482343c866f7486731ad638ef9af92bfe5fca9c7323d638e"
  end

  resource "dnaio" do
    url "https://files.pythonhosted.org/packages/source/d/dnaio/dnaio-0.4.tar.gz"
    sha256 "b0b46c9cc68cc842d1e5968ffd95de37a0987d2ac2c15a0613e2b12f9e47b918"
  end

  resource "xopen" do
    url "https://files.pythonhosted.org/packages/source/x/xopen/xopen-0.8.3.tar.gz"
    sha256 "c62496c789b4db1078fa3769d962669d8886b8f94b8dbdd2c3ea35c1b79e1e22"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "interleaved", shell_output("#{bin}/cutadapt -h 2>&1")
  end
end
