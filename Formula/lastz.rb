class Lastz < Formula
  desc "Align DNA sequences, a pairwise aligner"
  homepage "https://www.bx.psu.edu/~rsharris/lastz/"
  url "https://github.com/lastz/lastz/archive/1.04.03.tar.gz"
  sha256 "c58ed8e37c4b0e82492b3a2b3e12447a3c40286fb8358906d19f10b0a713e9f4"
  license "MIT"
  head "https://github.com/lastz/lastz"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "bb384aecd906f6a8c3589afc3a11a48b7c6c3661aa8edd751e59f904e2768ab7" => :catalina
    sha256 "5cb1a90c4e2c6d1cefa82c94a83977b1e008be94690c14cef5fef2099693424f" => :x86_64_linux
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
