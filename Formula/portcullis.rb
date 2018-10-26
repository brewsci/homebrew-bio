class Portcullis < Formula
  include Language::Python::Virtualenv
  # cite Mapleson_2017: "https://www.biorxiv.org/content/early/2017/11/10/217620"
  desc "Genuine splice junction prediction from BAM files"
  homepage "https://github.com/maplesond/portcullis"
  url "https://github.com/maplesond/portcullis/archive/Release-1.1.0.tar.gz"
  sha256 "872c0dbd7515229ecc22c9bdcd72eb78dfe93a3c0bfd14af52c448c142fe892a"
  revision 1
  head "https://github.com/maplesond/portcullis.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "52b593d877a74a1268a9bb75e40dc9fcd3ecc5e197d84dffec2fc01c0ec4bd79" => :sierra
    sha256 "e91724794110a2c76755b1e480c479f1707d3dff25b6b7ef4b20f82e885fbf5c" => :x86_64_linux
  end

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "python"
  depends_on "samtools"

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/34/fd/0cb98ea4df08c82af3de93da5b9f79d573c6ecc05098905f9cd6b0bece51/pandas-0.20.1.tar.gz"
    sha256 "42707365577ef69f7c9c168ddcf045df2957595a9ee71bc13c7997eecb96b190"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/a4/09/c47e57fc9c7062b4e83b075d418800d322caa87ec0ac21e6308bd3a2d519/pytz-2017.2.zip"
    sha256 "f5c056e8f62d45ba8215e5cb8f50dfccb198b4b9fbea8500674f3443e4689589"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    venv = virtualenv_create(libexec)
    resources.each do |r|
      venv.pip_install r
    end

    system "./build_boost.sh"
    system "./autogen.sh"
    system "./configure",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--disable-py-install",
      "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    cd "scripts/portcullis" do
      system "python3", *Language::Python.setup_install_args(prefix)
    end
    cd "scripts/junctools" do
      system "python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/portcullis --version")
  end
end
