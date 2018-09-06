class Oma < Formula
  # cite Altenhoff_2014: "https://doi.org/10.1093/nar/gku1158"
  # cite Altenhoff_2017: "https://doi.org/10.1093/nar/gkx1019"
  # cite Train_2017: "https://doi.org/10.1093/bioinformatics/btx229"
  # cite Altenhoff_2018: "https://doi.org/10.1101/397752"
  desc "Standalone package to infer orthologs with the OMA algorithm"
  homepage "https://omabrowser.org/standalone/"
  url "https://omabrowser.org/standalone/OMA.2.3.0.tgz"
  sha256 "7ff7440015555eab4bce72dba440b4e57cfb67272c3afb6241b1836cb845d821"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "4893b28658e53492c7ec7641eaeabcba66f2e3d4edaed4a4e2bc78d4fae0440e" => :sierra_or_later
    sha256 "c0e059b258cd1ac426b9ecb12d15f517e211cd5cb5fd1c696cbf672553fb2cad" => :x86_64_linux
  end

  depends_on "python"

  def install
    system "./install.sh", prefix, share
    share.mkpath
    (share/"README").write <<~EOS
      This directory contains data files for oma standalone
    EOS
    bin.install_symlink prefix/"OMA/bin/oma"
  end

  test do
    system "#{bin}/oma", "-p"
    File.exist?("parameters.drw")
    inreplace "parameters.drw", "DoGroupFunctionPrediction := true", "DoGroupFunctionPrediction := false"
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
    system "#{bin}/oma", "-s"
  end
end
