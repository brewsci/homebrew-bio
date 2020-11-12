class Oma < Formula
  include Language::Python::Virtualenv
  # cite Altenhoff_2019: "https://doi.org/10.1101/gr.243212.118"
  # cite Altenhoff_2017: "https://doi.org/10.1093/nar/gkx1019"
  # cite Train_2017: "https://doi.org/10.1093/bioinformatics/btx229"
  # cite Altenhoff_2014: "https://doi.org/10.1093/nar/gku1158"
  desc "Standalone package to infer orthologs with the OMA algorithm"
  homepage "https://omabrowser.org/standalone/"
  url "https://omabrowser.org/standalone/OMA.2.4.1.tgz"
  sha256 "a01f6f6ef219f53bfa1a48386ecaa7fdec022da6efb6cafed8778d65e0107a11"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "8d9dc53917ab9fc923cb5f42650d4690ea919339082cc5df368b5927d5857db2" => :mojave
    sha256 "d41b7f1cf868eeb797170329bbad3a09faf5ab11e2fdee60e1bbb5507ce51388" => :x86_64_linux
  end

  depends_on "numpy"
  depends_on "python"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/33/55/becf2b99556588d22b542f3412990bfc79b674e198d9bc58f7bbc333439e/biopython-1.75.tar.gz"
    sha256 "5060e4ef29c2bc214749733634051be5b8d11686c6590fa155c3443dcaa89906"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e4/19/8dfeef50623892577dc05245093e090bb2bab4c8aed5cad5b03208959563/lxml-4.4.2.tar.gz"
    sha256 "eff69ddbf3ad86375c344339371168640951c302450c5d3e9936e98d6459db06"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    resources.each do |r|
      venv.pip_install r
    end
    venv.pip_install_and_link buildpath/"hog_bottom_up"

    system "./install.sh", prefix, share, "--brew-python"
    share.mkpath
    (share/"README").write <<~EOS
      This directory contains data files for oma standalone
    EOS
    bin.install_symlink prefix/"OMA/bin/oma"
  end

  test do
    system "#{bin}/oma", "-p"
    File.exist?("parameters.drw")
    inreplace "parameters.drw" do |p|
      p.gsub! "DoGroupFunctionPrediction := true", "DoGroupFunctionPrediction := false"
      p.gsub! "SpeciesTree := 'estimate'", "SpeciesTree := '(genome1, genome2);'"
    end
    mkdir_p "DB"
    (testpath/"DB/genome1.fa").write <<~EOS
      >s1_1
      MEDSQSDMSIELPLSQETFSCLWKLLPPDDILPTTATGSPNSMEDLFLPQDVAELLEGPEEALQVSAPA
      >s1_2
      MWWLLRTLCFVHVIGSIFCFLNAKPKNPEANMNVSQIISYWGYESE
      >s1_3
      MQLLGRVICFVVGILLSGGPTGTISAVDPEANMNVTEIIMHWGYPGE
    EOS
    (testpath/"DB/genome2.fa").write <<~EOS
      >s2_1
      MTAMEESQSDISLELPLSQETFSGLWKLLPPEDILPSPHCMDDLLLPQDVEEFFEGPSEALRVSGAPAAQDPVT
      >s2_2
      MTIHNVSLFTTIFNIFKFCVLYITSSLGISLERFIKCRKVKNINDIVSE
    EOS
    system "#{bin}/oma"
    assert_predicate testpath/"Output/HierarchicalGroups.orthoxml", :exist?
  end
end
