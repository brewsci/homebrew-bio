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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "738044231b281dde9a4caff4d9a3a3dc4c9108d3a8b4386d8ec70a14fca9158a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f704581510cb702c5d8385755a8093acdcf07509a9bc90e683bb39590a652ae7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47021bf125db48e0451bab0876e839906165046aa136e71e54497856a3c64f5c"
    sha256 cellar: :any,                 x86_64_linux:  "258f303fe2d77aa9473b7b6bf87bd508f72c1c12ac8877cd6cd761ae7b2aa67c"
  end

  depends_on "numpy"
  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/df/3e/3c6aa8b2a7e6b791a34407736db32f59657001f0446ada31db73a3e0b7d5/biopython-1.87.tar.gz"
    sha256 "8456c803459b679a9712422e5a7fd9809f2f089bf69bb085f3b077946ac9bdbf"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
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
