class Lastz < Formula
  desc "Align DNA sequences, a pairwise aligner"
  homepage "https://www.bx.psu.edu/~rsharris/lastz/"
  url "https://github.com/lastz/lastz/archive/1.04.00.tar.gz"
  sha256 "a4c2c7a77430387e96dbc9f5bdc75874334c672be90f5720956c0f211abf9f5a"
  head "https://github.com/lastz/lastz"

  def install
    system "make", "definedForAll=-Wall"
    bin.install "src/lastz", "src/lastz_D"
    doc.install "README.lastz.html"
    pkgshare.install "test_data", "tools"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lastz --version", 1)
    assert_match "MAF", shell_output("#{bin}/lastz --help=formats", 1)
    dir = pkgshare/"test_data"
    assert_match "#:lav", shell_output("#{bin}/lastz #{dir}/pseudocat.fa #{dir}/pseudopig.fa")
  end
end
