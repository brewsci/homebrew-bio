class Cutadapt < Formula
  include Language::Python::Virtualenv
  # cite Martin_2011: "https://doi.org/10.14806/ej.17.1.200"
  desc "Removes adapter sequences, primers, and poly-A tails"
  homepage "https://github.com/marcelm/cutadapt"
  url "https://github.com/marcelm/cutadapt/archive/v1.16.tar.gz"
  sha256 "1dad7570be002f214f2188636cacc479e0fb675d8567335960cf1185906cf2c3"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "675a7ebb24a54e73716df4133d52062301013d22345932a658dbc7d75cd397ab" => :sierra
    sha256 "4d158948f51088ff553bc6621b57e74d6e02212bae2d2268075b48cef9ba8713" => :x86_64_linux
  end

  depends_on "python"

  resource "cython" do
    url "https://files.pythonhosted.org/packages/21/89/ca320e5b45d381ae0df74c4b5694f1471c1b2453c5eb4bac3449f5970481/Cython-0.28.5.tar.gz"
    sha256 "b64575241f64f6ec005a4d4137339fb0ba5e156e826db2fdb5f458060d9979e0"
  end

  resource "xopen" do
    url "https://files.pythonhosted.org/packages/e6/7d/15cfc41aa384e6a1dc60852d4df863524c647d852d62190fa638ba9abb58/xopen-0.3.5.tar.gz"
    sha256 "3a418d5d3eacc6645d8f002635308651bb6e47b9cabb19ae3abad600aa117ce3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "interleaved", shell_output("#{bin}/cutadapt -h 2>&1")
  end
end
