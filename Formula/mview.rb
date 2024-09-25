class Mview < Formula
  desc "Extracts and reformats the results of sequence searches or alignments"
  homepage "https://desmid.github.io/mview"
  url "https://github.com/desmid/mview/archive/refs/tags/v1.68.tar.gz"
  sha256 "4c3c75ba7f3cead82e641a83f3ad43b38169fef16aa8b9c8414e35f1eb1081c7"
  license "GPL-2.0-or-later"

  depends_on "perl"

  def install

    # To make MVIEW_HOME and MVIEW_LIB in mview script work
    inreplace "bin/mview" do |s|
      s.gsub!(
        %q($MVIEW_HOME = "/home/brown/HOME/work/MView/dev";),
        %Q($MVIEW_HOME = "#{prefix}";),
      )
      s.gsub!(
        %q($MVIEW_LIB = "$MVIEW_HOME/lib";),
        %Q($MVIEW_LIB = "$MVIEW_HOME/lib/mview#{version}";),
      )
    end

    lib_install_dir = lib/"mview#{version}/Bio"
    lib_install_dir.mkpath
    (lib_install_dir/"MView").install Dir["lib/Bio/MView/*"]
    (lib_install_dir/"Parse").install Dir["lib/Bio/Parse/*"]
    (lib_install_dir/"Util").install Dir["lib/Bio/Util/*"]

    bin.install "bin/mview"
  end

  test do
    system "wget", "https://rest.uniprot.org/uniprotkb/Q16602.fasta"
    system "#{bin}/mview", "-in", "fasta", "Q16602.fasta", "-width", "77"
  end
end
