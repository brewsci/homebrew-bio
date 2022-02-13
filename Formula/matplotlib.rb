class Matplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python 2D plotting library"
  homepage "https://matplotlib.org"
  url "https://files.pythonhosted.org/packages/8a/46/425a44ab9a71afd2f2c8a78b039c1af8ec21e370047f0ad6e43ca819788e/matplotlib-3.5.1.tar.gz"
  sha256 "b2e9810e09c3a47b73ce9cab5a72243a1258f61e7900969097a817232246ce1c"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "9bf624c16d6330f4bcebaba5411ae116d012f6903c36eebc0b6d7e48f275f281"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ec088b401c215bdfbb7a3387b27c7cb931b9b368f1ac23e963c43b94dfa152e0"
  end

  depends_on "libjpeg"      # Pillow
  depends_on "libtiff"      # Pillow
  depends_on "little-cms2"  # Pillow
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "webp"         # Pillow

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/34/45/a7caaacbfc2fa60bee42effc4bcc7d7c6dbe9c349500e04f65a861c15eb9/cycler-0.11.0.tar.gz"
    sha256 "9c87405839a19696e837b3b818fed3f5f69f16f1eec1a1ad77e043dcea9c772f"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/2d/4c/49ba863863502bb9fea19d8bd04a527da336b4a2698c8a0c7129e9cc2716/fonttools-4.29.1.zip"
    sha256 "2b18a172120e32128a80efee04cff487d5d140fe7d817deb648b2eee023a40e4"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/8e/87/259fde8cf07d06677f0a749cb157d079ebd00d40fe52faaab1a882a66159/kiwisolver-1.3.2.tar.gz"
    sha256 "fc4453705b81d03568d5b808ad8f09c77c47534f6ac2e72e733f9ca4714aa75c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/03/a3/f61a9a7ff7969cdef2a6e0383a346eb327495d20d25a2de5a088dbb543a6/Pillow-9.0.1.tar.gz"
    sha256 "6c8bc8238a7dfdaf7a75f5ec5a663f4173f8c367e5a39f87e720495e1eed75fa"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install "wheel"

    xy = Language::Python.major_minor_version "python3"
    site_packages = libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", site_packages
    venv.pip_install resources
    (lib/"python#{xy}/site-packages/homebrew-matplotlib.pth").write "#{site_packages}\n"

    venv.pip_install_and_link buildpath
  end

  test do
    ENV["PYTHONDONTWRITEBYTECODE"] = "1"
    system "python3", "-c", "import matplotlib"
  end
end
