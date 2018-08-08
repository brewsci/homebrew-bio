class NoExternalPyCXXPackage < Requirement
  fatal false

  satisfy do
    !quiet_system "python", "-c", "import CXX"
  end

  def message; <<~EOS
    *** Warning, PyCXX detected! ***
    On your system, there is already a PyCXX version installed, that will
    probably make the build of Matplotlib fail. In python you can test if that
    package is available with `import CXX`. To get a hint where that package
    is installed, you can:
        python -c "import os; import CXX; print(os.path.dirname(CXX.__file__))"
    See also: https://github.com/Homebrew/homebrew-python/issues/56
    EOS
  end
end

class Matplotlib < Formula
  desc "Python 2D plotting library"
  homepage "https://matplotlib.org"
  url "https://files.pythonhosted.org/packages/ec/ed/46b835da53b7ed05bd4c6cae293f13ec26e877d2e490a53a709915a9dcb7/matplotlib-2.2.2.tar.gz"
  sha256 "4dc7ef528aad21f22be85e95725234c5178c0f938e2228ca76640e5e84d8cde8"
  revision 1
  head "https://github.com/matplotlib/matplotlib.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "f8e0bfe7c8d02c2e3a0b052228b576d5a15f7a6efd50bb1e196afa6bb105ee94" => :sierra_or_later
    sha256 "4b0e34a68ad98f5475ef44503f6289c027804cc96d969d2c34dc5b8920c22eaf" => :x86_64_linux
  end

  depends_on NoExternalPyCXXPackage => :build
  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "libpng"
  depends_on "numpy"
  depends_on "python" => :recommended
  depends_on "python@2" => :recommended if !OS.mac? || MacOS.version <= :snow_leopard

  if build.with? "cairo"
    depends_on "py2cairo"
    depends_on "py3cairo"
  end

  depends_on "gtk+3" => :optional
  depends_on "pygobject3" if build.with? "gtk+3"

  depends_on "pygtk" => :optional
  depends_on "pygobject" if build.with? "pygtk"

  depends_on "pyqt" => :optional

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/dc/8c/7c9869454bdc53e72fb87ace63eac39336879eef6f2bf96e946edbf03e90/setuptools-33.1.1.zip"
    sha256 "6b20352ed60ba08c43b3611bdb502286f7a869fbfcf472f40d7279f1e77de145"
  end

  resource "Cycler" do
    url "https://files.pythonhosted.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "backports.functools_lru_cache" do
    url "https://files.pythonhosted.org/packages/57/d4/156eb5fbb08d2e85ab0a632e2bebdad355798dece07d4752f66a8d02d1ea/backports.functools_lru_cache-1.5.tar.gz"
    sha256 "9d98697f088eb1b0fa451391f91afb5e3ebde16bbdb272819fd091151fda4f1a"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/38/bb/bf325351dd8ab6eb3c3b7c07c3978f38b2103e2ab48d59726916907cd6fb/pyparsing-2.1.10.tar.gz"
    sha256 "811c3e7b0031021137fc83e051795025fcb98674d07eb8fe922ba4de53d39188"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/d0/e1/aca6ef73a7bd322a7fc73fd99631ee3454d4fc67dc2bee463e2adf6bb3d3/pytz-2016.10.tar.bz2"
    sha256 "7016b2c4fa075c564b81c37a252a5fccf60d8964aa31b7f5eae59aeb594ae02b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "subprocess32" do
    url "https://files.pythonhosted.org/packages/b8/2f/49e53b0d0e94611a2dc624a1ad24d41b6d94d0f1b0a078443407ea2214c2/subprocess32-3.2.7.tar.gz"
    sha256 "1e450a4a4c53bf197ad6402c564b9f7a53539385918ef8f12bdf430a61036590"
  end

  def install
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0" \
      || MacOS.version == :yosemite && MacOS::Xcode.installed? && MacOS::Xcode.version >= "7.0"
      ENV.delete "SDKROOT"
    end

    inreplace "setupext.py",
              "'darwin': ['/usr/local/'",
              "'darwin': ['#{HOMEBREW_PREFIX}'"

    Language::Python.each_python(build) do |python, version|
      bundle_path = libexec/"lib/python#{version}/site-packages"
      bundle_path.mkpath
      ENV.prepend_path "PYTHONPATH", bundle_path

      res = if version.to_s.start_with? "2"
        resources.map(&:name).to_set
      else
        resources.map(&:name).to_set - ["backports.functools_lru_cache", "subprocess32"]
      end
      res.each do |r|
        resource(r).stage do
          system python, *Language::Python.setup_install_args(libexec)
        end
      end
      (lib/"python#{version}/site-packages/homebrew-matplotlib-bundle.pth").write "#{bundle_path}\n"

      system python, *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    ENV["PYTHONDONTWRITEBYTECODE"] = "1"
    Language::Python.each_python(build) do |python, _|
      system python, "-c", "import matplotlib"
    end
  end
end
