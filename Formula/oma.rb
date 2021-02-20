class Oma < Formula
  include Language::Python::Virtualenv
  # cite Altenhoff_2019: "https://doi.org/10.1101/gr.243212.118"
  # cite Altenhoff_2017: "https://doi.org/10.1093/nar/gkx1019"
  # cite Train_2017: "https://doi.org/10.1093/bioinformatics/btx229"
  # cite Altenhoff_2014: "https://doi.org/10.1093/nar/gku1158"
  desc "Standalone package to infer orthologs with the OMA algorithm"
  homepage "https://omabrowser.org/standalone/"
  url "https://omabrowser.org/standalone/OMA.2.4.2.tgz"
  sha256 "73cc51300ecd162970a37b2ccb8992b66f710fafc76a00eab04b4d3857d19477"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "729dcb8eb4c80b0c5a0609c6dde988435f104a08c74df0b2891bc1f382dde221"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "43580d201fff38e760fc4109df638faef4e370ce7e75c88c3df07c9dc3312b5e"
  end

  depends_on "numpy"
  depends_on "python"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/89/c5/7fe326081276f74a4073f6d6b13cfa7a04ba322a3ff1d84027f4773980b8/biopython-1.78.tar.gz"
    sha256 "1ee0a0b6c2376680fea6642d5080baa419fd73df104a62d58a8baf7a8bbe4564"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/db/f7/43fecb94d66959c1e23aa53d6161231dca0e93ec500224cf31b3c4073e37/lxml-4.6.2.tar.gz"
    sha256 "cd11c7e8d21af997ee8079037fff88f16fda188a9776eb4b81c7e4c9c0a7d7fc"
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
