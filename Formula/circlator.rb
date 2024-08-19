class Circlator < Formula
  # cite Hunt_2015: "https://doi.org/10.1186/s13059-015-0849-0"
  include Language::Python::Virtualenv
  desc "Tool to circularize genome assemblies"
  homepage "https://sanger-pathogens.github.io/circlator/"
  url "https://github.com/sanger-pathogens/circlator/archive/refs/tags/v1.5.5-docker5.tar.gz"
  version "1.5.5"
  sha256 "c9c9d5cad0badb8b1c7707dce80235397cbd3846f8b686974b968f109a5222c6"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "011b738c33fc114b5da57a35430e9370d95d01166f729041fd46ff4a0d919aff"
    sha256 cellar: :any,                 ventura:      "713cf77d2eb247cedf3626dbaa1b2e0022d538135f1938f704268cb0835a1596"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d54a96a81958db06d8a5205463902e139558a3e597e5c2e2e9f14ffd64bc4e39"
  end

  depends_on "brewsci/bio/mummer"
  depends_on "bwa"
  depends_on "libdeflate"
  depends_on "openssl@3"
  depends_on "prodigal"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "samtools"
  depends_on "spades"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "cython" do
    url "https://files.pythonhosted.org/packages/84/4d/b720d6000f4ca77f030bd70f12550820f0766b568e43f11af7f7ad9061aa/cython-3.0.11.tar.gz"
    sha256 "7146dd2af8682b4ca61331851e6aebce9fe5158e75300343f80c07ca80b1faff"
  end

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/3d/5d/0413a31d184a20c763ad741cc7852a659bf15094c24840c5bdd1754765cd/et_xmlfile-1.1.0.tar.gz"
    sha256 "8eb9e2bc2f8c97e37a2dc85a09ecdcdec9d8a396530a6d5a33b30b9a92da0c5c"
  end

  resource "jdcal" do
    url "https://files.pythonhosted.org/packages/7b/b0/fa20fce23e9c3b55b640e629cb5edf32a85e6af3cf7af599940eb0c753fe/jdcal-1.4.1.tar.gz"
    sha256 "472872e096eb8df219c23f2689fc336668bdb43d194094b5cc1707e1640acfc8"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/3d/f9/88d94a75de065ea32619465d2f77b29a0469500e99012523b91cc4141cd1/openpyxl-3.1.5.tar.gz"
    sha256 "cf0e3cf56142039133628b5acffe8ef0c12bc902d2aadd3e0fe5878dc08d1050"
  end

  resource "pyfastaq" do
    url "https://files.pythonhosted.org/packages/28/9d/afbedb1994c9e9076d2bf87865ad74ed60a28cde651ce58952ac53534f28/pyfastaq-3.17.0.tar.gz"
    sha256 "40c6dc0cea72c0ab91d10e5627a26dea1783b7e5e3edcfff8e1dc960bfd71cdc"
  end

  resource "pymummer" do
    url "https://files.pythonhosted.org/packages/9f/a4/78890f48a84be3d4733262327da70220be8e11147c7d58b87ea979a0f866/pymummer-0.11.0.tar.gz"
    sha256 "199b8391348ff83760e9f63fdcee6208f8aa29da6506ee1654f1933e60665259"
  end

  resource "pysam" do
    url "https://files.pythonhosted.org/packages/a6/bc/e0a79d74137643940f5406121039d1272f29f55c5330e7b43484b2259da5/pysam-0.22.1.tar.gz"
    sha256 "18a0b97be95bd71e584de698441c46651cdff378db1c9a4fb3f541e560253b22"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"
    output = shell_output("#{bin}/circlator test outdir")
    assert_match "Finished run on test data OK", output
  end
end
