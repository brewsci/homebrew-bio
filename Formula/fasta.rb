class Fasta < Formula
  # cite Pearson_1990: "https://doi.org/10.1016/0076-6879(90)83007-V"
  desc "Classic FASTA sequence alignment suite"
  homepage "https://fasta.bioch.virginia.edu/"
  url "https://github.com/wrpearson/fasta36/archive/v36.3.8h_04-May-2020.tar.gz"
  version "36.3.8h.2020.05.04"
  sha256 "d13ec06a040e4d77bf6913af44b705d3ecc921131da018e71d24daf47d3664d3"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:fasta[._-])?v?(\d+(?:\.\d+)+[a-z]?)(?:[._-]|["' >])}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "7243b2aa0b0a8bd26748f1392639e111a692fd789bdc48622772778e5ea953ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fa74efd96bdcaa4aeb87fd7c4bf2c0df07e366f467750a3fc7a10e9adaabf630"
  end

  uses_from_macos "zlib"

  def install
    bin.mkpath
    arch = OS.mac? ? "os_x86_64" : "linux64_sse2"
    system "make", "-C", "src", "-f", "../make/Makefile.#{arch}"
    rm "bin/README"
    bin.install Dir["bin/*"]
    doc.install Dir["doc/*"]
    pkgshare.install "scripts", "test", "psisearch2", "data", "misc"
  end

  test do
    assert_match version.to_s.gsub(/.\d+.\d+.\d+$/, ''), shell_output("#{bin}/fasta36 -h 2>&1")
  end
end
