class Poretools < Formula
  include Language::Python::Virtualenv

  desc "Tools for working with nanopore sequencing data"
  homepage "https://poretools.readthedocs.org"
  # doi "10.1093/bioinformatics/btu555"
  # tag "bioinformatics"

  url "https://github.com/arq5x/poretools/archive/v0.6.0.tar.gz"
  sha256 "64d22ac045bf4b424bd709abb07fcdb6ef4d198a76213183de166a307646b9fa"
  revision 7

  bottle do
    cellar :any
    sha256 "e040d34e86d3b7989000ccd8d24d97a9e8025a11409bb4669a7afced55c6292e" => :sierra
    sha256 "ae1db4c366ce232875b07c3098b5be046b37a013fecd89f030698cd2525df434" => :el_capitan
    sha256 "42305e75f8b288c1a269bf6e79ffc7e4bd67d58b95a4bd7fb8110a9a0f82a195" => :yosemite
    sha256 "c0c5f3eec88ed7b278b2cfe1a2e0f12dbf7b1f0f1b8491579d54fb4f030d4f84" => :x86_64_linux
  end

  depends_on "pkg-config" => :build # for h5py
  depends_on "freetype" # for matplotlib
  depends_on "gcc" if OS.mac? # for gfortran for scipy
  depends_on "hdf5"
  depends_on "numpy"
  depends_on "python"
  depends_on "scipy"

  cxxstdlib_check :skip

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/c6/fe/97319581905de40f1be7015a0ea1bd336a756f6249914b148a17eefa75dc/Cython-0.24.1.tar.gz"
    sha256 "84808fda00508757928e1feadcf41c9f78e9a9b7167b6649ab0933b76f75e7b9"
  end

  resource "Cycler" do
    url "https://files.pythonhosted.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "h5py" do
    url "https://files.pythonhosted.org/packages/22/82/64dada5382a60471f85f16eb7d01cc1a9620aea855cd665609adf6fdbb0d/h5py-2.6.0.tar.gz"
    sha256 "b2afc35430d5e4c3435c996e4f4ea2aba1ea5610e2d2f46c9cae9f785e33c435"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/15/89/240b4ebcd63bcdde9aa522fbd2e13f0af3347bea443cb8ad111e3b4c6f3a/matplotlib-1.5.2.tar.gz"
    sha256 "8875d763c9e0d0ae01fefd5ebbe2b22bde5f080037f9467126d5dbee31785913"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/11/09/e66eb844daba8680ddff26335d5b4fead77f60f957678243549a8dd4830d/pandas-0.18.1.tar.gz"
    sha256 "d2e483692c7915916dffd1b83256ea9761b4224c8d45646ceddf48b977ee77b2"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/65/25/1bb68622ca70abc145ac9c9bcd0e837fccd2889d79cee641aa8604d18a11/pyparsing-2.1.8.tar.gz"
    sha256 "03a4869b9f3493807ee1f1cb405e6d576a1a2ca4d81a982677c0c1ad6177c56b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f7/c7/08e54702c74baf9d8f92d0bc331ecabf6d66a56f6d36370f0a672fc6a535/pytz-2016.6.1.tar.bz2"
    sha256 "b5aff44126cf828537581e534cc94299b223b945a2bb3b5434d37bf8c7f3a10c"
  end

  resource "seaborn" do
    url "https://files.pythonhosted.org/packages/ed/dc/f168ff9db34f8c03c568987b4f81603cd3df40dd8043722d526026381a91/seaborn-0.7.1.tar.gz"
    sha256 "fa274344b1ee72f723bab751c40a5c671801d47a29ee9b5e69fcf63a18ce5c5d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "test" do
    url "http://ftp.sra.ebi.ac.uk/vol1/ERA412/ERA412821/oxfordnanopore_native/MVA_filtered.tar.gz"
    sha256 "76b00286acba1f65c76a3869bc60e099190ce48d0a5822606ce222e80529e523"
  end

  def resources
    front_load = [resource("six")]
    front_load + (super - front_load - [resource("Cython"), resource("test")])
  end

  def install
    ENV.delete("SDKROOT")
    ENV["HDF5_DIR"] = Formula["hdf5"].opt_prefix

    resource("Cython").stage do
      system "python3", *Language::Python.setup_install_args(buildpath/"cython")
    end

    ENV.prepend_create_path "PATH", buildpath/"cython/bin"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python2.7/site-packages"

    virtualenv_install_with_resources

    (pkgshare/"test_data").install resource("test")
  end

  test do
    result = <<~EOS
      total reads	297
      total base pairs	260131
      mean	875.86
      median	795
      min	325
      max	3602
      N25	965
      N50	830
      N75	741
    EOS
    output = shell_output("#{bin}/poretools stats #{pkgshare}/test_data")
    assert_equal result, output
  end
end
