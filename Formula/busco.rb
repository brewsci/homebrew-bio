class Busco < Formula
  # cite Waterhouse_2017: "https://doi.org/10.1093/molbev/msx319"
  # cite Sim_o_2015: "https://doi.org/10.1093/bioinformatics/btv351"
  desc "Assess genome assembly completeness with single-copy orthologs"
  homepage "https://busco.ezlab.org"
  url "https://gitlab.com/ezlab/busco/repository/3.0.2/archive.tar.bz2"
  sha256 "cd0699545a126c7cc94604eef7c8dc50379b5d11becbad3a0f55d995a4c5e1c0"
  revision 2
  head "https://gitlab.com/ezlab/busco.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "dcd4dac383b75a661f950b5a5313824e36055ef00a149d8eb10b7dce46c0e4cc" => :sierra
    sha256 "119c1d4ea6ab45cca36fef4f160623aa1798f7412bf50d53a4148b482051432b" => :x86_64_linux
  end

  depends_on "augustus"
  depends_on "blast"
  depends_on "hmmer"
  depends_on "python"

  def install
    inreplace Dir["scripts/*.py"], "#!/usr/bin/env python", "#!#{HOMEBREW_PREFIX}/bin/python3"
    system "python3", "setup.py", "install", "--prefix=#{prefix}"

    libexec.install Dir["scripts/*"]
    (bin/"busco").write_env_script(libexec/"run_BUSCO.py", :AUGUSTUS_CONFIG_PATH => "#{Formula["augustus"].prefix}/config/")

    doc.install "BUSCO_v3_userguide.pdf"
    prefix.install "config"

    (prefix/"config/config.ini").write <<~EOS
      [busco]
      [tblastn]
      path = #{Formula["blast"].bin}
      [makeblastdb]
      path = #{Formula["blast"].bin}
      [augustus]
      path = #{Formula["augustus"].bin}
      [etraining]
      path = #{Formula["augustus"].bin}
      [gff2gbSmallDNA.pl]
      path = #{Formula["augustus"].prefix}/scripts/
      [new_species.pl]
      path = #{Formula["augustus"].prefix}/scripts/
      [optimize_augustus.pl]
      path = #{Formula["augustus"].prefix}/scripts/
      [hmmsearch]
      path = #{Formula["hmmer"].bin}
      [Rscript]
      path = #{HOMEBREW_PREFIX}/bin
    EOS
  end

  def caveats; <<~EOS
    You probably also want to download lineage datasets to run BUSCO:

      https://busco.ezlab.org

    To generate graphs, also make sure a working R is installed:

      brew cask install r

    or alternatively

      brew install r
  EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/busco --help")
  end
end
