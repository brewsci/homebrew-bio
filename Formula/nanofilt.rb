class Nanofilt < Formula
  include Language::Python::Virtualenv

  # cite De_Coster_2018: "https://doi.org/10.1093/bioinformatics/bty149"
  desc "Filtering and trimming of long read sequencing data"
  homepage "https://github.com/wdecoster/nanofilt"
  url "https://files.pythonhosted.org/packages/85/fb/6218b8f18dd3b39569cdfd2803f837730f392cc31df58d5ea927cc14c40c/NanoFilt-2.8.0.tar.gz"
  sha256 "47f4f4f8be834f011570a8d76d07cc12abe0686c8917607316a8ccfb3e20758c"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "ed128c5f1dd588cd8b2ba87d2f51098aa40d9ae2382ad9bfb4a7b4dca641946d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0e5ac69d718bc2e2073fc240d166d60e7b114a501004e41d7ae17185b5d9d939"
  end

  depends_on "numpy"
  depends_on "python@3.9"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/89/c5/7fe326081276f74a4073f6d6b13cfa7a04ba322a3ff1d84027f4773980b8/biopython-1.78.tar.gz"
    sha256 "1ee0a0b6c2376680fea6642d5080baa419fd73df104a62d58a8baf7a8bbe4564"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/8a/6f/7fcef020b5b305862cacf376183eaa0f907f2fa42f0b687b2a9a2c6cda4d/pandas-1.2.3.tar.gz"
    sha256 "df6f10b85aef7a5bb25259ad651ad1cc1d6bb09000595cab47e718cbac250b1d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/NanoFilt -v")
  end
end
