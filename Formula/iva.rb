class Iva < Formula
  include Language::Python::Virtualenv

  # cite Hunt_2015: "https://doi.org/10.1093/bioinformatics/btv120"
  desc "Iterative Virus Assembler"
  homepage "https://github.com/sanger-pathogens/iva"
  url "https://github.com/sanger-pathogens/iva/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "fc33e24926de84efc2eda9ad753e5f0facd191c7298e3c0dfe3016af25fb110f"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "74d66980f3f4d7ff31d7937fb84bb62d93eba219fbe6215bc123861bf5c05432"
  end

  depends_on "brewsci/bio/kmc"
  depends_on "brewsci/bio/smalt"
  depends_on "libdeflate"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "samtools"

  resource "cython" do
    url "https://files.pythonhosted.org/packages/4c/76/1e41fbb365ad20b6efab2e61b0f4751518444c953b390f9b2d36cf97eea0/Cython-0.29.32.tar.gz"
    sha256 "8733cf4758b79304f2a4e39ebfac5e92341bce47bcceb26c1254398b2f8c1af7"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/d9/c6/ad9dc9195c0e5d8879d2a28667aa45e087631576b40f9c954a086693a36d/networkx-2.8.6.tar.gz"
    sha256 "bd2b7730300860cbd2dafe8e5af89ff5c9a65c3975b352799d87a6238b4301a6"
  end

  resource "pyfastaq" do
    url "https://files.pythonhosted.org/packages/28/9d/afbedb1994c9e9076d2bf87865ad74ed60a28cde651ce58952ac53534f28/pyfastaq-3.17.0.tar.gz"
    sha256 "40c6dc0cea72c0ab91d10e5627a26dea1783b7e5e3edcfff8e1dc960bfd71cdc"
  end

  resource "pysam" do
    url "https://files.pythonhosted.org/packages/a0/10/f6d705984838f8620ff597dd99d3904aea7727b4824bee22de8f44b4ebd4/pysam-0.19.1.tar.gz"
    sha256 "dee403cbdf232170c1e11cc24c76e7dd748fc672ad38eb0414f3b9d569b1448f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage", shell_output("#{bin}/iva 2>&1", 2)
    assert_match "-f reads_fwd -r reads_rev", shell_output("#{bin}/iva --help 2>&1")
  end
end
