class Mreps < Formula
  # Kolpakov_2003: "https://doi.org/10.1093/nar/gkg617"
  desc "Identifying serial/tandem in DNA sequences"
  homepage "https://mreps.univ-mlv.fr/index.html"
  url "https://mreps.univ-mlv.fr/mreps-2.6.tar"
  sha256 "9fab4592646996e576d258e02b3d0606d45feb43a063d400aa04e766fd316296"

  def install
    system "make"
    bin.install "mreps"
  end

  test do
    # -h returns 1 ... https://github.com/gregorykucherov/mreps/issues/2
    assert_match version.to_s, shell_output("#{bin}/mreps -help 2>&1", 1)
  end
end
