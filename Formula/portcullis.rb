class Portcullis < Formula
  # cite Mapleson_2017: "https://www.biorxiv.org/content/early/2017/11/10/217620"
  include Language::Python::Virtualenv

  desc "Genuine splice junction prediction from BAM files"
  homepage "https://github.com/maplesond/portcullis"
  url "https://github.com/maplesond/portcullis/archive/refs/tags/Release-1.2.4.tar.gz"
  sha256 "9183c4e8108af1e813dbc35e537e16e5d0e13f53ed4c0a36b182c3f8bfcea438"
  license "GPL-3.0"
  head "https://github.com/maplesond/portcullis.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 sierra:       "52b593d877a74a1268a9bb75e40dc9fcd3ecc5e197d84dffec2fc01c0ec4bd79"
    sha256 x86_64_linux: "e91724794110a2c76755b1e480c479f1707d3dff25b6b7ef4b20f82e885fbf5c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "python"
  depends_on "samtools"

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
  end

  # pandas 0.20.1 (the original pin) predates PEP 517 and needs
  # pkg_resources/distutils, both gone from modern Python and setuptools.
  # pandas 2.2.2 in turn fails to compile under Homebrew's default Python
  # 3.14 because its pinned Cython 3.0.5 emits `[[maybe_unused]]` in the
  # middle of decl-specifiers, which the newer GCC rejects. pandas 2.3.3 is
  # the first release with Python 3.14 (cp314) support and an unbounded
  # Cython pin, so build isolation pulls a Cython that compiles cleanly.
  resource "pandas" do
    url "https://files.pythonhosted.org/packages/33/01/d40b85317f86cf08d853a4f495195c73815fdf205eef3993821720274518/pandas-2.3.3.tar.gz"
    sha256 "e05e1af93b977f7eafa636d043f9f94c7ee3ac81af99c13508215942e64c993b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/74/5b/e025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717/tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
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
