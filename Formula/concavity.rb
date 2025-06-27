class Concavity < Formula
  desc "Ligand binding site prediction from protein sequence and structure"
  homepage "https://compbio.cs.princeton.edu/concavity/"
  url "https://compbio.cs.princeton.edu/concavity/concavity_distr.tar.gz"
  version "0.1"
  sha256 "012461354b6cf6bcef50606f619bcf1e0b0f4681f190f81233869ebd2c88b89d"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "c54b2cb111edb9f5366e312d90af643f6264a054d1f07e678fba6bae16e198a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "815b2cf14685ef71c6aea79343a2791730e8bcb53706d8abb908f87c627e9a57"
  end

  depends_on "freeglut"

  def install
    system "make"
    bin.install Dir["bin/*/concavity"]
  end

  test do
    assert_match "Usage: concavity [options] pdbfile output_name", shell_output("#{bin}/concavity")
  end
end
