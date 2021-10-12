class Concavity < Formula
  desc "Ligand binding site prediction from protein sequence and structure"
  homepage "https://compbio.cs.princeton.edu/concavity/"
  url "https://compbio.cs.princeton.edu/concavity/concavity_distr.tar.gz"
  version "0.1"
  sha256 "012461354b6cf6bcef50606f619bcf1e0b0f4681f190f81233869ebd2c88b89d"
  license "GPL-3.0-or-later"

  def install
    system "make"
    bin.install Dir["bin/*/concavity"]
  end

  test do
    assert_match "Usage: concavity [options] pdbfile output_name", shell_output("#{bin}/concavity")
  end
end
