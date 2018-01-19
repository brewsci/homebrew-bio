class Oma < Formula
  desc "Standalone package to infer orthologs with the OMA algorithm"
  homepage "https://omabrowser.org/standalone/"
  url "https://omabrowser.org/standalone/OMA.2.2.0.tgz"
  sha256 "25ee17b92ef6631507311a93036c91154a42bcee8d033e3a3912836f2764040d"
  # cite "http://doi.org/10.1093/nar/gkx1019"
  # cite "http://doi.org/10.1093/bioinformatics/btx229"
  # cite "http://doi.org/10.1093/nar/gku1158"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "4893b28658e53492c7ec7641eaeabcba66f2e3d4edaed4a4e2bc78d4fae0440e" => :sierra_or_later
    sha256 "c0e059b258cd1ac426b9ecb12d15f517e211cd5cb5fd1c696cbf672553fb2cad" => :x86_64_linux
  end

  depends_on "python"

  def install
    system "./install.sh", prefix
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
