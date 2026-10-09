class Oma < Formula
  include Language::Python::Virtualenv

  # cite Altenhoff_2019: "https://doi.org/10.1101/gr.243212.118"
  # cite Altenhoff_2017: "https://doi.org/10.1093/nar/gkx1019"
  # cite Train_2017: "https://doi.org/10.1093/bioinformatics/btx229"
  # cite Altenhoff_2014: "https://doi.org/10.1093/nar/gku1158"
  desc "Standalone package to infer orthologs with the OMA algorithm"
  homepage "https://omabrowser.org/standalone/"
  url "https://github.com/DessimozLab/OmaStandalone/releases/download/2.8.0/OMA.2.8.0.tgz"
  sha256 "289be5dcfa0fcfadcdf0972c6863210e19512ff3efbdd37f2175e7d622ba8cb9"

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
    url "https://files.pythonhosted.org/packages/f6/a0/cf657d076ec56a5f9e5c29a560c1f97b8eb6ae6608dc8bc95b4e2437f129/biopython-1.88.tar.gz"
    sha256 "9aaa31c0bda4d059f7b2ee00bfdb5cbb73ade3057aa4b737a7cc0187091d071a"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    resources.each do |r|
      venv.pip_install r
    end
    venv.pip_install_and_link buildpath/"hog_bottom_up"
    system "./install.sh", prefix, share, "--brew-python"
    native_darwin = if OS.mac?
      "darwin-macos"
    elsif Hardware::CPU.arm?
      "darwin-linux-arm64"
    else
      "darwin-linux"
    end
    rm (prefix/"OMA/OMA.#{version}/darwin/bin").glob("darwin-*").reject { |f| f.basename.to_s == native_darwin }
    share.mkpath
    (share/"README").write <<~EOS
      This directory contains data files for oma standalone
    EOS
    bin.install_symlink prefix/"OMA/bin/oma"
  end

  test do
    system bin/"oma", "-p"
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
    system bin/"oma"
    assert_path_exists testpath/"Output/HierarchicalGroups.orthoxml"
  end
end
