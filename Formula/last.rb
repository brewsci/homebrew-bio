class Last < Formula
  # cite Kielbasa_2011: "https://doi.org/10.1101/gr.113985.110"
  desc "Find similar regions between sequences"
  homepage "http://last.cbrc.jp/"
  url "http://last.cbrc.jp/last-926.zip"
  sha256 "0bebd28ad4b0a6e377f53d25f0572b7202fc7cd1292ac482100767e052a5672c"
  head "http://last.cbrc.jp/last", :using => :hg

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "b9685214aafa8564147ea9ed7312511a00dd314a6d333dc81e26ec05378a7727" => :sierra
    sha256 "7d492b03fa60b7f154ad58a52ce861b351afb43687e507e41c32d1aafafeeaba" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    system "make", "install", "prefix=#{prefix}"
    doc.install Dir["doc/*"]
    pkgshare.install "data", "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lastal -V")
    system "#{bin}/lastdb", testpath/"db", pkgshare/"examples/mouseMito.fa"
    assert_predicate testpath/"db.suf", :exist?
    assert_match "lambda=",
      shell_output("#{bin}/lastal #{testpath}/db #{pkgshare}/examples/chickenMito.fa")
  end
end
