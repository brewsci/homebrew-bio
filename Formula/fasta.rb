class Fasta < Formula
  # cite Pearson_1990: "https://doi.org/10.1016/0076-6879(90)83007-V"
  desc "Classic FASTA sequence alignment suite"
  homepage "https://faculty.virginia.edu/wrpearson/fasta/"
  url "https://github.com/wrpearson/fasta36/archive/v36.3.8h_11-Feb-2020.tar.gz"
  version "36.3.8h"
  sha256 "916b327ac996151c808bd7066dea59c4ecb6035fc27c27fa8f011d49548867d6"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "7243b2aa0b0a8bd26748f1392639e111a692fd789bdc48622772778e5ea953ec" => :catalina
    sha256 "fa74efd96bdcaa4aeb87fd7c4bf2c0df07e366f467750a3fc7a10e9adaabf630" => :x86_64_linux
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
    assert_match version.to_s, shell_output("#{bin}/fasta36 -h 2>&1")
  end
end
