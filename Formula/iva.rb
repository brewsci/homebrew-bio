class Iva < Formula
  include Language::Python::Virtualenv

  # cite Hunt_2015: "https://doi.org/10.1093/bioinformatics/btv120"
  desc "Iterative Virus Assembler"
  homepage "https://github.com/sanger-pathogens/iva"
  url "https://github.com/sanger-pathogens/iva/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "fc33e24926de84efc2eda9ad753e5f0facd191c7298e3c0dfe3016af25fb110f"
  license "GPL-3.0-or-later"
  revision 1

  # Track the latest release; a stray mislabeled tag (1.5.0, pointing at a 2014
  # commit) otherwise wins the greatest-tag comparison and 404s.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "74d66980f3f4d7ff31d7937fb84bb62d93eba219fbe6215bc123861bf5c05432"
  end

  depends_on "brewsci/bio/kmc"
  depends_on "brewsci/bio/mummer"
  # iva's setup.py aborts the build unless smalt is on PATH (iva uses it as a
  # read mapper), and it was missing from the dependency list.
  depends_on "brewsci/bio/smalt"
  depends_on "libdeflate"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "python@3.10"
  depends_on "samtools"

  # pysam's bundled htslib links libbz2 and libcurl (alongside libz/liblzma/
  # libcrypto), which `brew linkage --test` flags on Linux.
  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    # libz and liblzma come from the tap's zlib-ng-compat and xz on Linux;
    # declare them so `brew linkage --test` passes.
    depends_on "xz"
    depends_on "zlib-ng-compat"
  end

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

  # packaging 24.2 drops the pyparsing dependency that 21.3 needed (and that was
  # not vendored, so `iva` failed at runtime with ModuleNotFoundError).
  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  # Old resources (Cython 0.29, pysam 0.19) build against pkg_resources, which
  # modern Python venvs no longer seed; vendor setuptools (<81) to provide it.
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")
    # Build pysam against the vendored Cython/setuptools without build isolation.
    # Under isolation pip builds pysam in a throwaway env that lacks setuptools'
    # pkg_resources (pysam 0.19.1's setup.py imports it), so the build aborts with
    # `No module named 'pkg_resources'`.
    %w[setuptools cython].each { |r| venv.pip_install resource(r) }
    venv.pip_install resource("pysam"), build_isolation: false
    venv.pip_install(resources.reject { |r| %w[setuptools cython pysam].include?(r.name) })
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "usage", shell_output("#{bin}/iva 2>&1", 2)
    assert_match "-f reads_fwd -r reads_rev", shell_output("#{bin}/iva --help 2>&1")
  end
end
