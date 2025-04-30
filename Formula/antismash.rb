class Antismash < Formula
  # cite Medema_2011: "https://doi.org/10.1093/nar/gkr466"
  # cite Blin_2013: "https://doi.org/10.1093/nar/gkt449"
  # cite Weber_2015: "https://doi.org/10.1093/nar/gkv437"
  # cite Blin_2017: "https://doi.org/10.1093/nar/gkx319"
  # cite Blin_2019: "https://doi.org/10.1093/nar/gkz310"
  # cite Blin_2021: "https://doi.org/10.1093/nar/gkab335"
  # cite Blin_2023: "https://doi.org/10.1093/nar/gkad344"
  include Language::Python::Virtualenv

  desc "Antibiotics & Secondary Metabolite Analysis SHell"
  homepage "https://antismash.secondarymetabolites.org/"
  url "https://github.com/antismash/antismash/archive/refs/tags/7-1-0-1.tar.gz"
  version "7.1.0.1"
  sha256 "1429986c369a81a7c1c60f2cb6efb1a28eacdb0290ec9c933477bad88d2b839d"
  license "AGPL-3.0-or-later"
  head "https://github.com/antismash/antismash.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "efcedbfe2e02d281cbae96ab77d73312a11174fb0dcd67b4e343cb01c82515b3"
    sha256 cellar: :any,                 arm64_sonoma:  "92296cbf3e66d80996628c8b4b25537591e7e679ed98d321fa534165f6491099"
    sha256 cellar: :any,                 ventura:       "12f82fbae77d44c32fab2a6f809b8cec08c6e50ac7dc322c8054ed4058e2ec34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83dc9aacaeb4b7dd019716a2427229630485276ada7d066292c9ce50eb66db39"
  end

  depends_on "cmake" => :build # scikit-learn
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for nrpys
  depends_on "blast"
  depends_on "brewsci/bio/fasttree"
  depends_on "brewsci/bio/glimmerhmm"
  depends_on "brewsci/bio/hmmer@2"
  depends_on "brewsci/bio/meme@4.11.2"
  depends_on "brewsci/bio/muscle"
  depends_on "ca-certificates"
  depends_on "diamond"
  depends_on "freetype"
  depends_on "hmmer"
  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "prodigal"
  depends_on "python@3.12" # 3.13 is not supported yet for biopython 1.85
  depends_on "qhull"
  depends_on "scipy"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "bcbio-gff" do
    url "https://files.pythonhosted.org/packages/20/03/769e86d61923c2febd229a9946bbfd0f5bc5ab09237481fb4c71e39d6966/bcbio-gff-0.7.1.tar.gz"
    sha256 "d1dc3294147b95baced6033f6386a0fed45c43767ef02d1223df5ef497e9cca6"
  end

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/89/c5/7fe326081276f74a4073f6d6b13cfa7a04ba322a3ff1d84027f4773980b8/biopython-1.78.tar.gz"
    sha256 "1ee0a0b6c2376680fea6642d5080baa419fd73df104a62d58a8baf7a8bbe4564"
  end

  resource "brawn" do
    url "https://files.pythonhosted.org/packages/1a/7d/abd734ec8b452d87f501cb57da1cb55f4ab999e5fe2d570c1f51374c70b5/brawn-1.0.1.tar.gz"
    sha256 "dd76831a9dee955692082f46209db645bceb2e48509cbe0eeb9d9e20f53cbb6c"
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/8d/9e/e4786569b319847ffd98a8326802d5cf8a5500860dbfc2df1f0f4883ed99/contourpy-1.2.1.tar.gz"
    sha256 "4d8908b3bee1c889e547867ca4cdc54e5ab6be6d3e078556814a22457f49423c"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/5a/25/886e197c97a4b8e254173002cdc141441e878ff29aaa7d9ba560cd6e4866/cython-3.0.12.tar.gz"
    sha256 "b988bb297ce76c671e28c97d017b95411010f7c77fa6623dd0bb47eed1aee1bc"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/67/ac/d7bf44ce57ff5770c267e63cff003cfd5ee43dc49abf677f8b7067fbd3fb/fonttools-4.50.0.tar.gz"
    sha256 "fa5cf61058c7dbb104c2ac4e782bf1b2016a8cf2f69de6e4dd6a865d2c969bb5"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/a3/51/8a4a67a8174ce59cf49e816e38e9502900aea9b4af672d0127df8e10d3b0/hatchling-1.25.0.tar.gz"
    sha256 "7064631a512610b52250a4d3ff1bd81551d6d1431c4eb7b72e734df6c74f4262"
  end

  resource "helperlibs" do
    url "https://files.pythonhosted.org/packages/b6/8a/dd905312ab030099c693966fd47947610251bcd3ac98ef76d16996388a68/helperlibs-0.2.1.tar.gz"
    sha256 "4ec2a0c17fdb75c42c692c5ec582580c14490c31235af5858ec12ad308265732"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/7c/c3/94c9e4886e8f33832690ab48fdac4a121a7bfec3e2c044c9f2762aa9068e/joblib-1.4.0.tar.gz"
    sha256 "1eb0dc091919cd384490de890cb5dfd538410a6d4b3b54eef09fb8c50b409b1c"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/03/8a/8975198ffd870ab2c04be32d200943a299fdf8a9b8e42b5e027a7a89fe4a/jsonschema-4.11.0.tar.gz"
    sha256 "706bbcafb49b1350fbcea40b209bdce8aed07c3288f7a77e9539bd5b3ddead3d"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/b9/2d/226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85ea/kiwisolver-1.4.5.tar.gz"
    sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  end

  resource "libsass" do
    url "https://files.pythonhosted.org/packages/79/b4/ab091585eaa77299558e3289ca206846aefc123fb320b5656ab2542c20ad/libsass-0.23.0.tar.gz"
    sha256 "6f209955ede26684e76912caf329f4ccb57e4a043fd77fe0e7348dd9574f1880"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/2f/08/b89867ecea2e305f408fbb417139a8dd941ecf7b23a2e02157c36da546f0/matplotlib-3.10.1.tar.gz"
    sha256 "e8d2d0e3881b129268585bf4765ad3ee73a4591d77b9a18c214ac7e3a79fb2ba"
  end

  resource "MOODS-python" do
    url "https://files.pythonhosted.org/packages/f7/34/c623e9b57e3e3f1edf030201603d8110bf9969921790d950836176be4749/MOODS-python-1.9.4.1.tar.gz"
    sha256 "b3b5e080cb0cd13c0fd175d0ee0d453fde3e42794fa7ac39a4f6db1ac5ddb4cc"
  end

  resource "nrpys" do
    url "https://files.pythonhosted.org/packages/07/4e/fa89f65eb34d685b6d24da6e49c057e8d2f68c7fd2e66e8431ddd3664af2/nrpys-0.1.1.tar.gz"
    sha256 "eab0e7762ca97109ec701da51b161cc431680fbaeeba5fc6d4cf2c190f69bb7f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/ce/3a/5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95ca/pyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "pysvg-py3" do
    url "https://files.pythonhosted.org/packages/63/92/a0d9d3c3f339bdd7f364e3e85033fc7649bb59d651dbab88ef9774e4cdaf/pysvg-py3-0.2.2.post3.tar.gz"
    sha256 "a1183aa5d89871298c11f25d28640edc3798b6ed1e2b2a95c30d35985d6431d0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "scikit-learn" do
    url "https://files.pythonhosted.org/packages/92/72/2961b9874a9ddf2b0f95f329d4e67f67c3301c1d88ba5e239ff25661bb85/scikit_learn-1.5.1.tar.gz"
    sha256 "0ea5d40c0e3951df445721927448755d3fe1d80833b0b7308ebff5d2a45e6414"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "threadpoolctl" do
    url "https://files.pythonhosted.org/packages/bd/55/b5148dcbf72f5cde221f8bfe3b6a540da7aa1842f6b491ad979a6c8b84af/threadpoolctl-3.5.0.tar.gz"
    sha256 "082433502dd922bf738de0d8bcc4fdcbf0979ff44c42bd40f5af8a282f6fa107"
  end

  def python3
    which("python3.12")
  end

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2" if OS.linux?
    venv = virtualenv_install_with_resources without: "matplotlib"
    # `matplotlib` needs extra inputs to use system libraries.
    # Ref: https://github.com/matplotlib/matplotlib/blob/v3.9.2/doc/install/dependencies.rst#use-system-libraries
    resource("matplotlib").stage do
      python = venv.root/"bin/python"
      system python, "-m", "pip", "install", "--config-settings=setup-args=-Dsystem-freetype=true",
                                             "--config-settings=setup-args=-Dsystem-qhull=true",
                                             *std_pip_args(prefix: false, build_isolation: true), "."
    end

    venv.pip_install_and_link buildpath
    # Fix minor warning in BCBio
    inreplace "#{libexec}/lib/python3.12/site-packages/BCBio/GFF/GFFParser.py",
              "compile(\"\\w+=\")", "compile(r\"\\w+=\")"
    (prefix/Language::Python.site_packages(python3)/"homebrew-antismash.pth").write venv.site_packages
  end

  def caveats
    <<~EOS
      Run `download-antismash-databases` to download the databases into
      #{opt_libexec}/lib/python3.12/site-packages/antismash/databases
      and `antismash --check-prereqs` to check the prerequisites.
    EOS
  end

  test do
    assert_match "antiSMASH", shell_output("#{bin}/antismash -h 2>&1")
    system python3, "-c", "import antismash"
  end
end
