class Anvio < Formula
  include Language::Python::Virtualenv
  # cite Eren_2015: "https://doi.org/10.7717/peerj.1319"
  desc "Analysis and visualization platform for ‘omics data"
  homepage "http://merenlab.org/projects/anvio/"
  url "https://files.pythonhosted.org/packages/4c/e3/2f3bddfcdde43a90574926a00261ad31c4dcff35496df511849e121641eb/anvio-5.1.tar.gz"
  sha256 "9f2bc87e19ae2b15ba7299a1e137ae8e9ccf89bbd10cb40f392f0bf4f1091a2c"

  depends_on "pkg-config" => :build
  depends_on "blast"
  depends_on "diamond"
  depends_on "freetype"
  depends_on "gcc" if OS.mac?
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "hmmer"
  depends_on "mcl"
  depends_on "muscle"
  depends_on "numpy"
  depends_on "prodigal"
  depends_on "python"
  depends_on "scipy"
  depends_on "sqlite" if OS.linux?

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/ec/ed/46b835da53b7ed05bd4c6cae293f13ec26e877d2e490a53a709915a9dcb7/matplotlib-2.2.2.tar.gz"
    sha256 "4dc7ef528aad21f22be85e95725234c5178c0f938e2228ca76640e5e84d8cde8"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/bd/99/04dc59ced52a8261ee0f965a8968717a255ea84a36013e527944dbf3468c/bottle-0.12.13.tar.gz"
    sha256 "39b751aee0b167be8dffb63ca81b735bbf1dd0905b3bc42761efedee8f123355"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/21/89/ca320e5b45d381ae0df74c4b5694f1471c1b2453c5eb4bac3449f5970481/Cython-0.28.5.tar.gz"
    sha256 "b64575241f64f6ec005a4d4137339fb0ba5e156e826db2fdb5f458060d9979e0"
  end

  resource "ete3" do
    url "https://files.pythonhosted.org/packages/21/17/3c49b7fafe10ed63bb7904ebf9764b98db726aa5fd482fb006818854bc04/ete3-3.1.1.tar.gz"
    sha256 "870a3d4b496a36fbda4b13c7c6b9dfa7638384539ae93551ec7acb377fb9c385"
  end

  resource "Django" do
    url "https://files.pythonhosted.org/packages/21/eb/534ac46e63c51eabbfc768d8c11cc851275f9047c8eaaefc17c41845987f/Django-2.0.2.tar.gz"
    sha256 "dc3b61d054f1bced64628c62025d480f655303aea9f408e5996c339a543b45f0"
  end

  resource "h5py" do
    url "https://files.pythonhosted.org/packages/34/07/4f8f6e4e478e9eabde25dea6b4478016e625b2dac6aaded78ba0316c86fe/h5py-2.8.0rc1.tar.gz"
    sha256 "c36b99dba05027f21e254ee4d37c1909408d2a06c46bab6e5108e92f7de479fb"
  end

  resource "cherrypy" do
    url "https://files.pythonhosted.org/packages/56/aa/91005730bdc5c0da8291a2f411aacbc5c3729166c382e2193e33f28044a3/CherryPy-8.9.1.tar.gz"
    sha256 "dfad2f34e929836d016ae79f9e27aff250a8a71df200bf87c3e9b23541e091c5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5b/0b/34be574b1ec997247796e5d516f3a6b6509c4e064f2885a96ed885ce7579/requests-2.12.4.tar.gz"
    sha256 "ed98431a0631e309bb4b63c81d561c1654822cb103de1ac7b47e45c26be7ae34"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/78/0a/aa90434c6337dd50d182a81fe4ae4822c953e166a163d1bf5f06abb1ac0b/psutil-5.1.3.tar.gz"
    sha256 "959bd58bdc8152b0a143cb3bd822d4a1b8f7230617b0e3eb2ff6e63812120f2b"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/25/a4/12a584c0c59c9fed529f8b3c47ca8217c0cf8bcc5e1089d3256410cfbdbc/mistune-0.7.4.tar.gz"
    sha256 "8517af9f5cd1857bb83f9a23da75aa516d7538c32a2c5d5c56f3789a9e4cd22f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/a4/09/c47e57fc9c7062b4e83b075d418800d322caa87ec0ac21e6308bd3a2d519/pytz-2017.2.zip"
    sha256 "f5c056e8f62d45ba8215e5cb8f50dfccb198b4b9fbea8500674f3443e4689589"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/27/85/f9e4f0e47a6f1410b1d737b74a1764868e9197e3197a2be843507b505636/pandas-0.23.1.tar.gz"
    sha256 "50b52af2af2e15f4aeb2fe196da073a8c131fa02e433e105d95ce40016df5690"
  end

  resource "scikit-learn" do
    url "https://github.com/scikit-learn/scikit-learn/archive/0.19.1.tar.gz"
    sha256 "2947f531ad52e81b2436b26608d8198778ac0b4baa7d2925db8b3b3fcb39c8a2"
  end

  def install
    ENV["HTSLIB_CONFIGURE_OPTIONS"] = "--disable-libcurl"
    ENV["HAVE_LIBCURL"] = "False"
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_lib/"python#{version}/site-packages"
    ENV.prepend_path "PYTHONPATH", Formula["scipy"].opt_lib/"python#{version}/site-packages"

    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/anvi-profile", "--version"
  end
end
