class Elph < Formula
  desc "Gibbs sampler for finding motifs in DNA or protein sequences"
  homepage "https://example.com"
  url "ftp://ftp.cbcb.umd.edu/pub/software/elph/ELPH-1.0.1.tar.gz"
  sha256 "6d944401d2457d75815a34dbb5780f05df569eb1edfd00909b33c4c4c4ff40b9"

  def install
    cd "sources" do
      system "make", "SEARCHDIRS=-I." # avoid Clang error about "-I-"
      bin.install "elph"
    end
    prefix.install "Readme.ELPH"
  end

  test do
    assert_match "Motif finder program ELPH", shell_output("#{bin}/elph -h 2>&1", 1)
  end
end
