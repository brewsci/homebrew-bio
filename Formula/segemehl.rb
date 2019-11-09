class Segemehl < Formula
  # cite Otto_2014: "https://doi.org/10.1093/bioinformatics/btu146"
  desc "Short read aligner based on enhanced suffix arrays"
  homepage "http://www.bioinf.uni-leipzig.de/Software/segemehl"
  url "http://www.bioinf.uni-leipzig.de/Software/segemehl/downloads/segemehl-0.3.4.tar.gz"
  sha256 "e4336f03d0d15126dbb1c6368c7e80421b0c7354f4a6b492d54d7d14cf5a7f51"

  depends_on "htslib"
  depends_in "ncurses"

  def install
    system "make"
    bin.install "segemehl.x"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/segemehl.x -h 2>&1", 1)
  end
end
