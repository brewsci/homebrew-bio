class Elph < Formula
  desc "Gibbs sampler for finding motifs in DNA or protein sequences"
  homepage "http://www.cbcb.umd.edu/software/elph/"
  url "ftp://ftp.cbcb.umd.edu/pub/software/elph/ELPH-1.0.1.tar.gz"
  sha256 "6d944401d2457d75815a34dbb5780f05df569eb1edfd00909b33c4c4c4ff40b9"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6fc80e2e63f9a1f2cc468557001af523f6e16796a5547428d99be2fae1292f96" => :sierra
    sha256 "8c2dba8b5fd0b8a575f166123c25063b4efdb26d6eb8a209e9f1d1dee890590c" => :x86_64_linux
  end

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
