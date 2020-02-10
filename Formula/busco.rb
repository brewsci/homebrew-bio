class Busco < Formula
  include Language::Python::Virtualenv

  # cite Seppey_2019: "https://doi.org/10.1007/978-1-4939-9173-0_14"
  # cite Waterhouse_2017: "https://doi.org/10.1093/molbev/msx319"
  # cite Sim_o_2015: "https://doi.org/10.1093/bioinformatics/btv351"
  desc "Assess genome assembly completeness with single-copy orthologs"
  homepage "https://busco.ezlab.org"
  url "https://gitlab.com/ezlab/busco/repository/4.0.2/archive.tar.gz"
  sha256 "e88f56a601083d449524b018adc323b71d45cffd37505a5a4c5c0fb5c1615781"
  head "https://gitlab.com/ezlab/busco.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "26206163c9eee9a1db507c71efe29d29c51223fcf7ea9238f725d1c5c3066d75" => :catalina
    sha256 "9d9cf66b0c7d8b9992d4c35528be9f8076659c1650a731cf1db8a2ac461d5ab3" => :x86_64_linux
  end

  depends_on "augustus"
  depends_on "blast"
  depends_on "hmmer"
  depends_on "numpy"
  depends_on "prodigal"
  depends_on "python"
  depends_on "sepp"

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
      path = #{Formula["blast"].bin}
      command = tblastn
      [makeblastdb]
      path = #{Formula["blast"].bin}
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
    (bin/"busco").write_env_script libexec/"bin/busco", :BUSCO_CONFIG_FILE => libexec/"config.ini"
  end

  def caveats; <<~EOS
    R must be installed to generate graphs.
      brew install r
    #{"Or:\n  brew cask install r" if OS.mac?}
  EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/busco --help")
  end
end
