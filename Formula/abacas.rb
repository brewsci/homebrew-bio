class Abacas < Formula
  # cite Assefa_2009: "https://doi.org/10.1093/bioinformatics/btp347"
  desc "Automatic contiguation of assembled sequences"
  homepage "https://abacas.sourceforge.io"
  url "https://jaist.dl.sourceforge.net/project/abacas/abacas.1.3.1.pl"
  sha256 "0afee209a4f879987b320e2f882bc0eab540a7a712a81a5f01b9795d2749310d"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "3c46bf2eeb2ef4de53a4778bb72d5dfd182f810f2e4191d345d30848180e8549"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a486b8b94ea27fe8734d443487fb1a9530f5525c4416c0b94dd5a8be8d7949e9"
  end

  # Remove depends_on "brewsci/bio/mummer"

  def install
    inreplace "abacas.1.3.1.pl", "/usr/local/bin/perl", "/usr/bin/env perl"
    bin.install "abacas.1.3.1.pl" => "abacas"
  end

  test do
    assert_match "promer", shell_output("#{bin}/abacas -h 2>&1", 255)
  end
end
