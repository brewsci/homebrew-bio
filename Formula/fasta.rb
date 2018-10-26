class Fasta < Formula
  # cite Pearson_1990: "https://doi.org/10.1016/0076-6879(90)83007-V"
  desc "Classic FASTA sequence alignment suite"
  homepage "http://faculty.virginia.edu/wrpearson/fasta/"
  url "https://github.com/wrpearson/fasta36/archive/fasta-v36.3.8g.tar.gz"
  sha256 "fa5318b6f8d6a3cfdef0d29de530eb005bfd3ca05835faa6ad63663f8dce7b2e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "389a3bb347fefd53e505923cfc4bc5f45caf9d08c5312161091789dd8d15e749" => :sierra
    sha256 "33403940543bad786c488197361f71ed00847f35793409107ba1103b7a8485bf" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

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
