class Matplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python 2D plotting library"
  homepage "https://matplotlib.org"
  url "https://files.pythonhosted.org/packages/7b/b3/7c48f648bf83f39d4385e0169d1b68218b838e185047f7f613b1cfc57947/matplotlib-3.3.3.tar.gz"
  sha256 "b1b60c6476c4cfe9e5cf8ab0d3127476fd3d5f05de0f343a452badaad0e4bdec"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "609aaf08da967a0a7729bfb9502f29f9303617154612195f0b2100c4dd2797a7" => :catalina
    sha256 "d118af398ad5341b4eb16f3e44195ceae12295311a819b6e0c6b14e8558c2c52" => :x86_64_linux
  end

  depends_on "libjpeg"      # Pillow
  depends_on "libtiff"      # Pillow
  depends_on "little-cms2"  # Pillow
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "webp"         # Pillow

  resource "Cycler" do
    url "https://files.pythonhosted.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/90/55/399ab9f2e171047d28933ae4b686d9382d17e6c09a01bead4a6f6b5038f4/kiwisolver-1.3.1.tar.gz"
    sha256 "950a199911a8d94683a6b10321f9345d5a3a8433ec58b217ace979e18f16e248"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/73/59/3192bb3bc554ccbd678bdb32993928cb566dccf32f65dac65ac7e89eb311/Pillow-8.1.0.tar.gz"
    sha256 "887668e792b7edbfb1d3c9d8b5d8c859269a0f0eba4dda562adb95500f60dbba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
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
