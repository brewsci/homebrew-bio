class Busco < Formula
  include Language::Python::Virtualenv

  # cite Seppey_2019: "https://doi.org/10.1007/978-1-4939-9173-0_14"
  # cite Waterhouse_2017: "https://doi.org/10.1093/molbev/msx319"
  # cite Sim_o_2015: "https://doi.org/10.1093/bioinformatics/btv351"
  desc "Assess genome assembly completeness with single-copy orthologs"
  homepage "https://busco.ezlab.org"
  url "https://gitlab.com/ezlab/busco/repository/4.0.4/archive.tar.gz"
  sha256 "1d42e4b3a53a7e4f3c4c15485ffcc4dac9fd6cbb3a4ac410ca90774c34d4dcb1"
  head "https://gitlab.com/ezlab/busco.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "d1a7014dfee399ab4284f4d874469e44cfc47dd5949db8d7e48a4fbc8d749b12" => :catalina
    sha256 "76512513d732fc75fc7d7ef0af1ecd004c4f77e7c85693bdccd82b674e615bf1" => :x86_64_linux
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
    (bin/"busco").write_env_script libexec/"bin/busco",
      :BUSCO_CONFIG_FILE    => libexec/"config.ini",
      :AUGUSTUS_CONFIG_PATH => "#{Formula["augustus"].prefix}/config/"
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
