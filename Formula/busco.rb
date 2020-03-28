class Busco < Formula
  include Language::Python::Virtualenv

  # cite Seppey_2019: "https://doi.org/10.1007/978-1-4939-9173-0_14"
  # cite Waterhouse_2017: "https://doi.org/10.1093/molbev/msx319"
  # cite Sim_o_2015: "https://doi.org/10.1093/bioinformatics/btv351"
  desc "Assess genome assembly completeness with single-copy orthologs"
  homepage "https://busco.ezlab.org"
  url "https://gitlab.com/ezlab/busco/repository/4.0.5/archive.tar.bz2"
  sha256 "f65299b96a14ef1d909e6186107a52336b744428cdacd204fd811002e89811dc"
  head "https://gitlab.com/ezlab/busco.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9c076a4c04a883de25d4678205f3c8c353384c94dc92d602a1ccde53e1418d28" => :catalina
    sha256 "99233ec7fd13048b37ba737b40b32eebd132dab59ca5ad6d2babef07ea3ea09e" => :x86_64_linux
  end

  depends_on "augustus"
  depends_on "brewsci/bio/blast@2.2"
  depends_on "brewsci/bio/sepp"
  depends_on "hmmer"
  depends_on "numpy"
  depends_on "prodigal"
  depends_on "python"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/ff/f4/0ce39bebcbb0ff619426f2bbe86e60bc549ace318c5a9113ae480ab2adc7/biopython-1.76.tar.gz"
    sha256 "3873cb98dad5e28d5e3f2215a012565345a398d3d2c4eebf7cd701757b828c72"
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
      :BUSCO_CONFIG_FILE    => libexec/"config.ini",
      :AUGUSTUS_CONFIG_PATH => "#{Formula["augustus"].prefix}/config/"
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
