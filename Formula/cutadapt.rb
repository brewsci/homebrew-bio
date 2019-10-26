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
    sha256 "108bd35c16edcb2f6dee522d95e441dbc8fb489555f8c15b4f2851ab6e972862" => :sierra
    sha256 "02fa5cf6cd2f2fc590aa075d9610c090a4e59dc80628c8c7053dab1466d674b6" => :x86_64_linux
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
