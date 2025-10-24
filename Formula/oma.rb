class Oma < Formula
  include Language::Python::Virtualenv
  # cite Altenhoff_2019: "https://doi.org/10.1101/gr.243212.118"
  # cite Altenhoff_2017: "https://doi.org/10.1093/nar/gkx1019"
  # cite Train_2017: "https://doi.org/10.1093/bioinformatics/btx229"
  # cite Altenhoff_2014: "https://doi.org/10.1093/nar/gku1158"
  desc "Standalone package to infer orthologs with the OMA algorithm"
  homepage "https://omabrowser.org/standalone/"
  url "https://omabrowser.org/standalone/OMA.2.7.0.tgz"
  sha256 "7354488a2ce3b415d420f7a93dad7a65dec3f05838d5a71c32f175146295ba91"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, monterey:     "5c7d45fb493156defbf5082151e843f0dce3977d3464c4230fbf05d6b91f22d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b1c873f9cc4a6d468c491fdfa8216eca5b9cb97190ddccd87dec111da4cbfeeb"
  end

  depends_on "numpy"
  depends_on "python"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/db/ca/1d5fab0fedaf5c2f376d9746d447cdce04241c433602c3861693361ce54c/biopython-1.85.tar.gz"
    sha256 "5dafab74059de4e78f49f6b5684eddae6e7ce46f09cfa059c1d1339e8b1ea0a6"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/c5/ed/60eb6fa2923602fba988d9ca7c5cdbd7cf25faa795162ed538b527a35411/lxml-6.0.0.tar.gz"
    sha256 "032e65120339d44cdc3efc326c9f660f5f7205f3a535c1fdbf898b29ea01fb72"
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
    assert_path_exists testpath/"Output/HierarchicalGroups.orthoxml"
  end
end
