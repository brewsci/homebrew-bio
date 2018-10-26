class Lastz < Formula
  desc "Align DNA sequences, a pairwise aligner"
  homepage "https://www.bx.psu.edu/~rsharris/lastz/"
  url "https://github.com/lastz/lastz/archive/1.04.00.tar.gz"
  sha256 "a4c2c7a77430387e96dbc9f5bdc75874334c672be90f5720956c0f211abf9f5a"
  head "https://github.com/lastz/lastz"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2ae5c3000f42435fdb7f3f7bbd1ae5f80f799ec10ad59d37f1fe093cc94f0bf6" => :sierra
    sha256 "9ae732027be6e7ef474170a0e372e494aca32818a67602eda7fe99f73c2eeb14" => :x86_64_linux
  end

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
