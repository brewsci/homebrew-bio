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
  revision 1
  head "https://github.com/antismash/antismash.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "2ff34ee73fed805df8886ccd8df52f44954f6571f5784a08f9445c62f2af8080"
    sha256 cellar: :any,                 ventura:      "afaa9fe5de6ba026dc2b24ef5846cdb19c00b3628c395576388e42c626426b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e55dbefa5f83597be56a296f7e34c4de395e949d57f9428de5d725824224511e"
  end

  depends_on "cmake" => :build # scikit-learn
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build # for nrpys
  depends_on "blast"
  depends_on "brewsci/bio/fasttree"
  depends_on "brewsci/bio/glimmerhmm"
  depends_on "brewsci/bio/hmmer@2"
  depends_on "brewsci/bio/meme@4.11.2"
  depends_on "brewsci/bio/muscle"
  depends_on "ca-certificates"
  depends_on "cython"
  depends_on "diamond"
  depends_on "freetype"
  depends_on "hmmer"
  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "prodigal"
  depends_on "python-matplotlib"
  depends_on "python@3.13"
  depends_on "scipy"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "patchelf" => :build
    depends_on "ca-certificates"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/49/7c/fdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17f/attrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "bcbio-gff" do
    url "https://files.pythonhosted.org/packages/20/03/769e86d61923c2febd229a9946bbfd0f5bc5ab09237481fb4c71e39d6966/bcbio-gff-0.7.1.tar.gz"
    sha256 "d1dc3294147b95baced6033f6386a0fed45c43767ef02d1223df5ef497e9cca6"
  end

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/db/ca/1d5fab0fedaf5c2f376d9746d447cdce04241c433602c3861693361ce54c/biopython-1.85.tar.gz"
    sha256 "5dafab74059de4e78f49f6b5684eddae6e7ce46f09cfa059c1d1339e8b1ea0a6"
  end

  resource "brawn" do
    url "https://files.pythonhosted.org/packages/c2/c8/fe7b560057829c6b4018f4ddf8927b5bbf7333493ecefaa0a53c0590d503/brawn-1.0.2.tar.gz"
    sha256 "8c993df898fdf359cd619f035c5c14a0e4ab7587dc6be3d1d970eb7efaf30ec9"
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/25/c2/fc7193cc5383637ff390a712e88e4ded0452c9fbcf84abe3de5ea3df1866/contourpy-1.3.1.tar.gz"
    sha256 "dfd97abd83335045a913e3bcc4a09c0ceadbe66580cf573fe961f4a825efa699"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/1c/8c/9ffa2a555af0e5e5d0e2ed7fdd8c9bef474ed676995bb4c57c9cd0014248/fonttools-4.56.0.tar.gz"
    sha256 "a114d1567e1a1586b7e9e7fc2ff686ca542a82769a296cef131e4c4af51e58f4"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/8f/8a/cc1debe3514da292094f1c3a700e4ca25442489731ef7c0814358816bb03/hatchling-1.27.0.tar.gz"
    sha256 "971c296d9819abb3811112fc52c7a9751c8d381898f36533bb16f9791e941fd6"
  end

  resource "helperlibs" do
    url "https://files.pythonhosted.org/packages/b6/8a/dd905312ab030099c693966fd47947610251bcd3ac98ef76d16996388a68/helperlibs-0.2.1.tar.gz"
    sha256 "4ec2a0c17fdb75c42c692c5ec582580c14490c31235af5858ec12ad308265732"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/7c/c3/94c9e4886e8f33832690ab48fdac4a121a7bfec3e2c044c9f2762aa9068e/joblib-1.4.0.tar.gz"
    sha256 "1eb0dc091919cd384490de890cb5dfd538410a6d4b3b54eef09fb8c50b409b1c"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/01/80/cce854d0921ff2f0a9fa831ba3ad3c65cee3a46711addf39a2af52df2cfd/rpds_py-0.22.3.tar.gz"
    sha256 "e32fee8ab45d3c2db6da19a5323bc3362237c8b653c70194414b892fd06a080d"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/82/59/7c91426a8ac292e1cdd53a63b6d9439abd573c875c3f92c146767dd33faf/kiwisolver-1.4.8.tar.gz"
    sha256 "23d5f023bdc8c7e54eb65f03ca5d5bb25b601eac4d7f1a042888a1f45237987e"
  end

  resource "libsass" do
    url "https://files.pythonhosted.org/packages/79/b4/ab091585eaa77299558e3289ca206846aefc123fb320b5656ab2542c20ad/libsass-0.23.0.tar.gz"
    sha256 "6f209955ede26684e76912caf329f4ccb57e4a043fd77fe0e7348dd9574f1880"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
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
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8b/1a/3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2/pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "pysvg-py3" do
    url "https://files.pythonhosted.org/packages/63/92/a0d9d3c3f339bdd7f364e3e85033fc7649bb59d651dbab88ef9774e4cdaf/pysvg-py3-0.2.2.post3.tar.gz"
    sha256 "a1183aa5d89871298c11f25d28640edc3798b6ed1e2b2a95c30d35985d6431d0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "scikit-learn" do
    url "https://files.pythonhosted.org/packages/9e/a5/4ae3b3a0755f7b35a280ac90b28817d1f380318973cff14075ab41ef50d9/scikit_learn-1.6.1.tar.gz"
    sha256 "b4fc2525eca2c69a59260f583c56a7557c6ccdf8deafdba6e060f94c1c59738e"
  end

  resource "threadpoolctl" do
    url "https://files.pythonhosted.org/packages/bd/55/b5148dcbf72f5cde221f8bfe3b6a540da7aa1842f6b491ad979a6c8b84af/threadpoolctl-3.5.0.tar.gz"
    sha256 "082433502dd922bf738de0d8bcc4fdcbf0979ff44c42bd40f5af8a282f6fa107"
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
    which("python3.13")
  end

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2" if OS.linux?
    venv = virtualenv_create(libexec, python3)
    venv.pip_install(resources)
    site_packages = Language::Python.site_packages(python3)

    venv.pip_install_and_link buildpath
    # Fix minor warning in BCBio
    inreplace "#{libexec}/lib/python3.13/site-packages/BCBio/GFF/GFFParser.py",
              "compile(\"\\w+=\")", "compile(r\"\\w+=\")"
    (prefix/site_packages/"homebrew-antismash.pth").write venv.site_packages
  end

  def caveats
    <<~EOS
      Run `download-antismash-databases` to download the databases into
      #{opt_libexec}/lib/python3.13/site-packages/antismash/databases
      and `antismash --check-prereqs` to check the prerequisites.
    EOS
  end

  test do
    assert_match "antiSMASH", shell_output("#{bin}/antismash -h 2>&1")
    system python3, "-c", "import antismash"
  end
end
