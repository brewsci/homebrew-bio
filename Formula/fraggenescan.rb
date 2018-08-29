class Fraggenescan < Formula
  # cite Rho_2010: "https://doi.org/10.1093/nar/gkq747"
  desc "Predicting genes in short and error-prone reads"
  homepage "https://github.com/COL-IU/FragGeneScan"
  url "https://downloads.sourceforge.net/project/fraggenescan/FragGeneScan1.31.tar.gz"
  sha256 "cd3212d0f148218eb3b17d24fcd1fc897fb9fee9b2c902682edde29f895f426c"

  depends_on "perl" unless OS.mac?

  def install
    system "make", "clean"
    prefix.install Dir["*"]
    bin.install_symlink Dir["#{prefix}/run_FragGeneScan.pl"]
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/run_FragGeneScan.pl 2>&1")
  end
end
