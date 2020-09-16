class Nanofilt < Formula
  include Language::Python::Virtualenv

  # cite De_Coster_2018: "https://doi.org/10.1093/bioinformatics/bty149"
  desc "Filtering and trimming of long read sequencing data"
  homepage "https://github.com/wdecoster/nanofilt"
  url "https://files.pythonhosted.org/packages/77/13/f811015d65a4984db6b9f5ef722a2cfbaf577697840c68facc8cbe2a2c2c/NanoFilt-2.7.1.tar.gz"
  sha256 "78de51ecdc8a22d4edc59bc9c858812c9b861e80bc9ec7626ad8d0f6cac68b4b"
  license "GPL-3.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "bbf3e5519315971faac2ef4f24b4eb26b3b7814963cc43957deeea388cd380d9" => :catalina
    sha256 "f1a2c76d6bf5cc0b9e1f8fe1f585c6fdbb7f674a3a8b2d4340f284b95338553b" => :x86_64_linux
  end

  depends_on "python@3.8"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/3d/2f/d9df24de05d651c5e686ee8fea3afe3985c03ef9ca02f4cc1e7ea10aa31e/biopython-1.77.tar.gz"
    sha256 "fb1936e9ca9e7af8de1050e84375f23328e04b801063edf0ad73733494d8ec42"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/f1/2c/717bdd12404c73ec0c8c734c81a0bad7048866bc36a88a1b69fd52b01c07/numpy-1.19.0.zip"
    sha256 "76766cc80d6128750075378d3bb7812cf146415bd29b588616f72c943c00d598"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/31/29/ede692aa6547dfc1f07a4d69e8411b35225218bcfbe9787e78b67a35d103/pandas-1.0.5.tar.gz"
    sha256 "69c5d920a0b2a9838e677f78f4dde506b95ea8e4d30da25859db6469ded84fa8"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/f6/94fee50f4d54f58637d4b9987a1b862aeb6cd969e73623e02c5c00755577/pytz-2020.1.tar.gz"
    sha256 "c35965d010ce31b23eeb663ed3cc8c906275d6be1a34393a1d73a41febf4a048"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/NanoFilt -v")
  end
end
