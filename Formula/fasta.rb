class Fasta < Formula
  # cite Pearson_1990: "https://doi.org/10.1016/0076-6879(90)83007-V"
  desc "Classic FASTA sequence alignment suite"
  homepage "http://faculty.virginia.edu/wrpearson/fasta/"
  url "http://faculty.virginia.edu/wrpearson/fasta/fasta36/fasta-36.3.8.tar.gz"
  sha256 "e235458afd16591bbcd5b89b639497e20346841091440a2445593318510a2262"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "42da3c4ddbd524a851ef42f7136e8f259ae7f5356aaec45e27a9b81499e7502c" => :sierra_or_later
    sha256 "57da1c1bd4883bc500101ede9732b4b31304aa12c9f55cd0d80f53e2e07447d6" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    bin.mkpath
    arch = OS.mac? ? "os_x86_64" : "linux"
    system "make", "-C", "src", "-f", "../make/Makefile.#{arch}"
    rm "bin/README"
    bin.install Dir["bin/*"]
    doc.install Dir["doc/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fasta36 -h 2>&1")
  end
end
