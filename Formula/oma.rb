class Oma < Formula
  include Language::Python::Virtualenv
  # cite Altenhoff_2019: "https://doi.org/10.1101/gr.243212.118"
  # cite Altenhoff_2017: "https://doi.org/10.1093/nar/gkx1019"
  # cite Train_2017: "https://doi.org/10.1093/bioinformatics/btx229"
  # cite Altenhoff_2014: "https://doi.org/10.1093/nar/gku1158"
  desc "Standalone package to infer orthologs with the OMA algorithm"
  homepage "https://omabrowser.org/standalone/"
  url "https://omabrowser.org/standalone/OMA.2.6.0.tgz"
  sha256 "6ec1b638e586a6a6896662d7182e7507d98d10d3b47fa0977db065d5e552eb1e"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "62859a53f9fa4f56d227089e6010e131c20c84dbc3de0d66bbdc3f07e6cf7913"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0d440610328984f5fc89d12d41dd25325659526a5cdbb32260f969c339de6992"
  end

  depends_on "numpy"
  depends_on "python"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/ad/a4/237edd5f5e5b68d9543c79bcd695ef881e6317fbd0eae1b1e53e694f9d54/biopython-1.81.tar.gz"
    sha256 "2cf38112b6d8415ad39d6a611988cd11fb5f33eb09346666a87263beba9614e0"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
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
