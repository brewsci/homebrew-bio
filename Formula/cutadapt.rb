class Cutadapt < Formula
  include Language::Python::Virtualenv
  # cite Martin_2011: "https://doi.org/10.14806/ej.17.1.200"
  desc "Removes adapter sequences, primers, and poly-A tails"
  homepage "https://github.com/marcelm/cutadapt"
  url "https://github.com/marcelm/cutadapt.git",
      :tag      => "v2.3",
      :revision => "4b17cda378360cd6f95ee36348cd843c690dfa13"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "108bd35c16edcb2f6dee522d95e441dbc8fb489555f8c15b4f2851ab6e972862" => :sierra
    sha256 "02fa5cf6cd2f2fc590aa075d9610c090a4e59dc80628c8c7053dab1466d674b6" => :x86_64_linux
  end

  depends_on "python"

  resource "cython" do
    url "https://files.pythonhosted.org/packages/source/C/Cython/Cython-0.29.7.tar.gz"
    sha256 "55d081162191b7c11c7bfcb7c68e913827dfd5de6ecdbab1b99dab190586c1e8"
  end

  resource "dnaio" do
    url "https://files.pythonhosted.org/packages/source/d/dnaio/dnaio-0.3.tar.gz"
    sha256 "47e4449affad0981978fe986684fc0d9c39736f05a157f6cf80e54dae0a92638"
  end

  resource "xopen" do
    url "https://files.pythonhosted.org/packages/source/x/xopen/xopen-0.5.1.tar.gz"
    sha256 "80757c50816162001e8629524f907426f82e885c168705a276abc649739ef200"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "interleaved", shell_output("#{bin}/cutadapt -h 2>&1")
  end
end
