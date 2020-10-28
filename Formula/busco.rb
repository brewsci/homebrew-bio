class Busco < Formula
  include Language::Python::Virtualenv

  # cite Seppey_2019: "https://doi.org/10.1007/978-1-4939-9173-0_14"
  # cite Waterhouse_2017: "https://doi.org/10.1093/molbev/msx319"
  # cite Sim_o_2015: "https://doi.org/10.1093/bioinformatics/btv351"
  desc "Assess genome assembly completeness with single-copy orthologs"
  homepage "https://busco.ezlab.org"
  url "https://gitlab.com/ezlab/busco/repository/4.1.4/archive.tar.bz2"
  sha256 "a5954f788fa00c613bc55210731c27d2665e1302ac8b840f180b96a9926d51a9"
  license "MIT"
  head "https://gitlab.com/ezlab/busco.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "253d2bcda073ac985bb1240b1f818b0e643abd047311eb05a12f0acabfcf9047" => :catalina
    sha256 "ddc1c727ae2ca7f465fe6a214d0124fcc7ec6244d4266f7e7272447afa0f28be" => :x86_64_linux
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
