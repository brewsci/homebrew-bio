class Busco < Formula
  include Language::Python::Virtualenv

  # cite Seppey_2019: "https://doi.org/10.1007/978-1-4939-9173-0_14"
  # cite Waterhouse_2017: "https://doi.org/10.1093/molbev/msx319"
  # cite Sim_o_2015: "https://doi.org/10.1093/bioinformatics/btv351"
  desc "Assess genome assembly completeness with single-copy orthologs"
  homepage "https://busco.ezlab.org"
  url "https://gitlab.com/ezlab/busco/-/archive/5.0.0/busco-5.0.0.tar.gz"
  sha256 "0d4ff765a751a5d22771bece2c1992b1e780da57504501a82752f307be86dcef"
  license "MIT"
  head "https://gitlab.com/ezlab/busco.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "f9a62517ec79bd2f2c9cff93e54b439492c6817881073c8078f0681ea8dd3deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1bce16b5608a8389835c63d8eecfb55b0c7a73ad28815f6eeb79d701b3d0f28a"
  end

  depends_on "augustus"
  depends_on "brewsci/bio/blast@2.2"
  depends_on "brewsci/bio/sepp"
  depends_on "hmmer"
  depends_on "numpy"
  depends_on "prodigal"
  depends_on "python@3.9"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/89/c5/7fe326081276f74a4073f6d6b13cfa7a04ba322a3ff1d84027f4773980b8/biopython-1.78.tar.gz"
    sha256 "1ee0a0b6c2376680fea6642d5080baa419fd73df104a62d58a8baf7a8bbe4564"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/8a/6f/7fcef020b5b305862cacf376183eaa0f907f2fa42f0b687b2a9a2c6cda4d/pandas-1.2.3.tar.gz"
    sha256 "df6f10b85aef7a5bb25259ad651ad1cc1d6bb09000595cab47e718cbac250b1d"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  def install
    virtualenv_install_with_resources
    # Save the original config file somewhere and write our own
    cp buildpath/"config/config.ini", libexec/"config.default.ini"

    (libexec/"config.ini").write <<~EOS
      [busco_run]
      [tblastn]
      path = #{Formula["blast@2.2"].bin}
      command = tblastn
      [makeblastdb]
      path = #{Formula["blast@2.2"].bin}
      command = makeblastdb
      [augustus]
      path = #{Formula["augustus"].bin}
      command = augustus
      [etraining]
      path = #{Formula["augustus"].bin}
      command = etraining
      [gff2gbSmallDNA.pl]
      path = #{Formula["augustus"].prefix}/scripts/
      command = gff2gbSmallDNA.pl
      [new_species.pl]
      path = #{Formula["augustus"].prefix}/scripts/
      command = new_species.pl
      [optimize_augustus.pl]
      path = #{Formula["augustus"].prefix}/scripts/
      command = optimize_augustus.pl
      [hmmsearch]
      path = #{Formula["hmmer"].bin}
      command = hmmsearch
      [sepp]
      path = #{Formula["sepp"].bin}
      command = run_sepp.py
      [prodigal]
      path = #{Formula["prodigal"].bin}
      command = prodigal
    EOS

    # Remove virtualenv_install_with_resources link and write our own
    rm bin/"busco"
    (bin/"busco").write_env_script libexec/"bin/busco",
      BUSCO_CONFIG_FILE:    libexec/"config.ini",
      AUGUSTUS_CONFIG_PATH: "#{Formula["augustus"].prefix}/config/"
  end

  def caveats
    <<~EOS
      R must be installed to generate graphs.
        brew install r
      #{"Or:\n  brew cask install r" if OS.mac?}
    EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/busco --help")
  end
end
